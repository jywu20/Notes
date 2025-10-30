Overview of GPU programming
========

# Rendering, the vertex-fragment pipeline

The physical basis of rendering can be found [here](../../Physics-new/geometrical-optics/kinetic.pdf)/
The rendering equation (and its generalizations) clearly is computationally intensive to solve,
and there is not a single way to solve it,
so if the rendering process is to be hardware accelerated,
it's a good idea to find a common ground for all types of rendering techniques
one can naturally think off,
including those that are semi-empirical and do not actually solve the rendering equation.

Before 2008, this common ground was the so-called **rasterization pipeline**,
that's to say, the vertex-fragment shading pipeline.
At first the GPU architecture had a one-to-one correspondence with stages in the pipeline.
People then squeeze physics-based rendering algorithms into this process.
What could be squeezed into this pipeline turned out to be quite generic
(although incredibly hacky tricks were needed),
and this general-purpose GPU movement eventually gave us CUDA and a revolution of GPU architectures,
ultimately leading to the "small multithreading supercomputer" model we're used to today.

Today people still use the old vertex-fragment pipeline,
although the separation between vertex shaders and fragment shaders (see below)
is now a software convention enforced by some graphic APIs,
and different types of shaders are now run on [the same hardware cores](../HPC/overview.md).
These graphic APIs are essentially faking the old, fixed, stage-based GPU pipeline
on a much more generic hardware platform.
This can be beneficial because telling the driver that a kernel is a fragment shader or a vertex shader
helps it optimize it and also help modern GPUs to do micro-scheduling
(which still has hardware accelerations for rasterization, texture fetching, and blending).
The rasterization pipeline is now among several possible pipelines that are pre-defined in modern graphic APIs,
the rest being e.g. ray tracing.

# Overview of the rasterization pipeline

The physical intuition behind the rasterization pipeline
is you're looking at something with a hard surface (the case described by the rendering equation),
so rendering, as a math problem, means mapping a 3D mesh of **vertices** into a 2D image.

## Representing the object being rendered: the vertices

As is said above, an object (or more precisely, its surface) to be rendered
is made of a list of vertices, or maybe we can say it's a mesh of vertices,
because typically we supply additional information about 
[which points are consider to be close to each other](#representing-the-object-being-rendered-the-indices).
Here is a list of information stored at each vertex
if we're going to do a serious rendering.

First, we need its position, often stored as a 4D vector to make translation expressible as matrix multiplication.
Second, we need the normal vector at it, for calculating lighting (as in the $\cos \theta$ factor in the rendering equation).

We also want to store things like texture coordinates,
which maps this vertex to a point on a pre-defined 2D texture image,
so that each point on the surface can get a texture value.
The term *texture* is slightly misleading here as you can pass anything related to
how the vertex should be rendered in the final image:
it can be color or material property or whatever is useful.
A property defined on each point of a surface takes the form of $(u, v) \to \phi$,
where $(u, v)$ is the system of coordinates on the surface.
We can then rescale the coordinate space into a square,
which means we "skin" the object being rendered and rescale it into a one by one image,
i.e. the 2D texture image.
We can then record the (rescaled) $u, v$ of each vertex into it.
The main reason we do not store the actual value of $\phi$ at each vertex is 
it's generally sparse (the property is a smooth function of the position of the vertex),
so it makes more sense to have a low-resolution texture image and then calculate the texture of each vertex by interpolation on the fly.
The texture coordinates are also called **UV**, for the obvious reason.

There are scenarios when we need to specify pre-vertex (that's to say, predetermined before the vertices are processed by the GPU) "colors" of vertices.
It doesn't need to be the real color:
for instance it can be a ratio guiding the shading pipeline to mix different textures.

Because of the high flexibility required for the vertex structure,
graphic APIs typically don't have a pre-defined vertex struct.
Instead, we manually write something like 
```C++
struct Vertex {
    glm::vec3 position;   // 3D position
    glm::vec3 normal;     // surface normal
    glm::vec2 uv;         // texture coordinates
    glm::vec3 tangent;    // optional, for normal mapping
    glm::vec4 color;      // optional vertex color
};
```
And of course, for pre-CUDA GPGPU players, we can sneak whatever we want in the name of "vertex".

## Representing the object being rendered: the indices

Besides the list of vertices,
we also need to record which vertices are close to each other
and are supposed to appear in a same **primitive** (like a triangle after triangulation of the object).
This is typically done by having a list of three-element tuples recording indices of 
vertices belonging to the same triangle,
like `[[0, 1, 2], [2, 1, 3]]`.

## Calculating the contribution of a vertex to the output image

The next step, called vertex shading,
roughly speaking, is to calculate the contribution of a vertex to the output image.
This is a rather vague notion and what exactly is done at this step is left to the developer to decide.
The hard constraint is, a **vertex shader** works on a single vertex:
therefore things like interpolating properties of vertices of a primitive can't be done at this stage.
On the other hand, calculating the brightness of a vertex, depending on the normal direction and the texture of that vertex, is something you can put into a vertex shader.
(This is known as **per-vertex lighting**.)
Another thing we're supposed to do is to convert the spatial coordinates of a vertex to where it is in the image output,
or, more frequently, to the so-called clip space.

Therefore, a vertex shader may look like this:
```glsl
layout(location = 0) in vec3 position;  // vertex position
layout(location = 1) in vec3 normal;    // vertex normal
layout(location = 2) in vec2 uv;        // texture coordinates
layout(location = 3) in vec4 color;     // vertex color

struct VertexOutput {
    vec4 clipPos;     // gl_Position
    vec3 normal;
    vec2 uv;
    vec4 color;
};

out VertexOutput vs_out;

void main() {
    vs_out.clipPos = P * V * M * vec4(position, 1.0);
    vs_out.normal = normal;
    vs_out.uv = uv;
    vs_out.color = color;
    gl_Position = vs_out.clipPos;
}
```
We can also add pre-vertex lighting etc. into it.

Here the `in` statements specify the input arguments, and the `out` statements specify the outputs.
Note that GPUs are supposed to be programmed in a "you just do things" way,
often *without* keeping a call stack,
and thus the `return` keyword is not used here:
a shader lives in its *own world*,
and the `position`, `normal`, `gl_Position` etc. variables are like input and output pins of a microcontroller:
a shader (or more generally, any kernel) does not feel like being a part of a bigger software system.
It gets launched and does something and then writes things to ports that connect it to a *fixed* pipeline and stops.
(Although the same can be said about CUDA, the latter is much more general-purpose,
and a GPU kernel looks much closer to an ordinary function and not a `main` function of a MCU.
That's why a CUDA kernel is written in a much more normal way.)


## Mapping primitives in the object to primitives in the output image

Once the object to be rendered has been represented by a mesh of vertices,
and some processing has been done to each vertex,
the GPU automatically does something to prepare for fragment-based processing.
This involves several tasks.

First, we need **primitive assembly**, that's to say,
the GPU checks out what vertices form a primitive,
and after that automatically interpolate the properties of that primitive 
based on the `gl_Position` of the vertices calculated in vertex shading.
Then, based on `gl_Position`, it groups pixels on the screen in the same primitive into a **fragment**,
which is called **rasterization**.
These steps are fully automatic and are not programmable:
they're hardwired into the circuits.

## Fragment shading

Now the GPU has a set of fragments and each fragment has interpolated attributes.
A **fragment shader** runs once per fragment, and does processes that should be done to fragments and not vertices.
This may be texture fetching and interpolation:
we have interpolated UV coordinates and we can then do an interpolation of the texture and retrieve the texture value corresponding to the fragment.
We can also do lighting here, 
utilizing normal and light directions.
The expected output is the color.

Fragment shaders are written in the same shader language used to write vertex shaders.
Again, output is done by direct assignment to e.g. `gl_FragColor`
or user defined output variables.

The whole rendering pipeline ends here.

## Physics-based rendering with the rasterization API

Direct illumination is straightforward to implement within the rasterization pipeline.
Global illumination, that's to say, consideration of secondary and even higher order reflections,
isn't so easy, because the rasterization pipeline is not capable of iterative algorithms.

# Shader-based computing

It is clear that shader languages - the C-like languages for writing MCU program-like GPU kernels - are quite domain-generic,
and are not restricted to the vertex-fragment pipeline.
If the user is able to design their own pipelines (directly or periphrastically),
they can achieve general purpose computing even without CUDA.
This is an old-fashioned way to do GPGPU, known as "shader-based computation".

The process however is rather cumbersome.
To pass a 2D image to the GPU, the easiest way is to `glFramebufferTexture2D` it to a certain place of the framebuffer,
and then use `glGetUniformLocation` and `glUniform1i` to link a variable name in the shader to that slot of the framebuffer.
So many function calls, just to pass one variable.

A natural reaction is to just let variables be variables,
that's to say, we should be able to allocate GPU memory and copy data to it in the same way we write C code.
And because there will likely be more types of kernels than the old vertex/fragment ones,
the `in` and `out` syntax should be obsoleted.
This is basically how CUDA works.
Therefore we can say that the most important contribution of CUDA is to the CPU part.

In theory, one can write rendering software in CUDA, although this is non-standard.
The modern alternative to OpenGL is Vulkan, which allows more fine-grained control of GPUs
but adds even more boilerplate code.

