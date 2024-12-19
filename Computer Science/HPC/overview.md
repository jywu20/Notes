Aspects of modern high performance computing (HPC)
==========

# Von Neumann architecture

The von Neumann architecture can be seem as an instance of random-access machines.
It contains a memory unit, a control unit, and an arithmetic/logic unit (ALU).
Just like how a Turing machine works,
the program is stored in the memory,
together with the data.
The program is instruction-based, meaning that a program is a list of instructions,
each of which consists of an operation and one or more address referring to the memory.
When a von Neumann machine works,
the control unit fetches one instruction 
from the address in the memory unit given by the program counter,
and decide what to do with the data in the memory
(which is then done by the ALU; this is known as *data flow*),
and also which instruction to execute next
(known as *control flow*).

Von Neumann architecture is a theoretical concept.
It can be clearly seen that the memory unit is just the RAM in an actual computer,
and the control unit and the ALU are implemented as the CPU.
To make an actual, practical computer,
the architecture needs some extension.

## Registers

First, although in theory, a random-access machine doesn't need registers apart from the memory,
for convenience in programming
(for example, almost every program handles its memory by dividing it into a stack and a heap,
so a stack register is desirable)
and speed (fetching data from the memory is time-consuming; we'll go back to this topic later),
and also easier manipulation of the behavior of the CPU
without endlessly expanding the instruction set
(we'll soon see instances of this type of registers),
a series of registers are usually built into the CPU.

## Interrupts

We want interactive user interface,
and not just loading data manually to the memory and let the computer run and collect the output,
and therefore there needs to be a way to let the CPU respond to real-time demands.
This is known as *interrupts*.
An interrupt is triggered by setting an *interrupt register* to a certain value.
The CPU is designed in such a way that it checks the interrupt registers from time to time,
between instructions and sometimes even when a complicated instruction is going on,
and when an interrupt finally arrives,
the CPU stops and looks up what to do (known as the *interrupt handler*)
in the interrupt vector table (IVT).
Here "what to do" usually means an address in the IVT,
which will be then loaded into the program counter
and the CPU then starts to execute instructions of the interrupt handler as usual
(so some sort of state saving has to be there),
until it reaches a return instruction,
which means the interrupt handler finishes.
The CPU then goes back to what it was doing before the interrupt.

We can see that this mechanism is not that different from calling a subroutine:
the only difference being that the subroutine invocation is not caused by a regular instruction,
but by a certain value of one of the interrupt registers.
This straightforward way to treat real-time IO shows an advantage of the instruction-based approach.
Often, the real difference between equivalent formalisms 
is shown by how they interact with the outside world:
this is also why we say general relativity is different
from other theories which also works with $g$:
even if they give the same EOM about the metric tensor when there is no external fields,
they give different predictions when matter and radiation are introduced in the most natural way.
Similarly this is how two Lagrangians giving the same EOM give different predictions
when they are inserted into the path integral.

The mechanism of interrupt is essentially how we can use mouse and keyboard to control our computers:
a part of a device driver is an interrupt handler,
and when a keystroke caused an interrupt,
the keyboard driver, being called by the CPU to handle the interrupt,
may clear the interrupts, make sure that it's not receiving another interrupt from an earlier keystroke,
calling other programs (usually the OS) to take down what has been typed, etc.
It is also a common way to implement *system calls*,
where an application asks the operation system to do something for it.

## Accessing peripheral devices

We have already seen how to ask CPU to deal with real-time events.
We also want the CPU to give us real-time feedback,
for example writing and drawing something on the screen.
In modern computers this is usually done by sending a message to the graphics card,
so the question is how.
In theory, we can expand the instruction set of the CPU to do this,
but a more elegant and general way is to reuse concepts like "address"
and treat message sending as writing to a pre-defined address.

In *memory-mapped IO*, the same address space is used to refer to both the main memory and IO/devices.
Therefore some areas of the address bus are reserved for IO,
and writing to an address dedicated to say the graphics card
leads to the graphics card receiving a message.

In *port-mapped IO* we are also writing to some addresses to send a message to a peripheral device,
but the address space is different:
we may for example have an entire bus dedicated to IO or an extra IO pin on the CPU's physical interface.
To do port-mapped IO, extra instructions are usually needed.

The PCIe standard is designed to connect the CPU with all peripheral devices.

## Disks

For permanent storage, we dump data to disks.
Nowadays usually a disk means a hard drive,
but in earlier days we also have soft drives and CD or DVD drives.
Disks are also "peripheral" in the sense that they are not a direct component 
in the minimal CPU-memory von Neumann machine,
so they are also managed by PCIe,
and they are accessed by the CPU by the standard way the CPU visits peripheral devices:
writing something or reading something to or from a designated address, etc.

## Virtual memory

## Operating systems

An *operation system (OS)* makes things easier for writing programs.
It registers all drivers during initialization
and also manages the page table for the virtual memory mechanism.
The registered drivers handle the interrupts caused by 
we trying to talk to the computer by typing, moving the mouse, touching the screen, etc.,
and that's how we are able to talk to the computer.
The OS also helps launch hosted programs
and manages the memory space in an appropriate way
so that the programs feel as if they are running in independent machines,
and our mental model when designing a hosted program that just implements some algorithms can just be a RAM.
When a hosted program indeed needs to talk to peripheral devices,
it does system calls (often sealed into standard libraries),
which again are just interrupts handled by the OS.

## BIOS and bootstrap

What is discussed above is how a computer works when it has already been started.
But this doesn't answer the question how a computer is started,
which is quite non-trivial,
considering that so many things rely on the OS,
which however is stored in the hard drive and not in the memory when a computer is about to start.
The BIOS is responsible to load things into the memory and let CPU run them
so that the computer can start.

## Co-evolution of computer architecture and programming models

The C programming language neatly maps what is commonly considered idiomatic assembly code on the simplest von Neumann machine to its primitives.
Introduction of concepts like peripheral devices, user-triggered interrupt, and memory-mapped IO can also be captured easily with C primitives,
although usually platform-dependent implementations are needed and for example assignment to specific addresses is needed.
But here we can see the idea to add new functionalities to the von Neumann architecture in a way that can be "absorbed" into the old programming model.
The virtual memory mechanism is a clearer instance of this.

However, the C-like programming model is not always a good representation of certain hardware acceleration schemes.
For example it's generally not a good idea to minimally modify a C code and find some ways to compile it to a FPGA design
(although there are ways to do FPGA using C).
It takes non-trivial efforts to make programming of modern high-performance hardwares C-like.
Some aspects of this are discussed in https://stackoverflow.com/questions/74756422/do-processors-have-optimizations-and-architecture-preferences-targeted-firstly-o:
for example, the "variable-assignment" mindset requires cache coherence:
therefore if one variable that can be seen by two threads is modified by one,
the modification should instantly be seen by the other.
Another possibility to go beyond the C-like programming model is that 
since cache is important for performance, maybe some way to control it manually would be a good idea.
Sometimes the architecture is changed so radically that there is no longer a difference between cache and RAM:
instead multiple very fast (but small) RAMs containing code and data are used as the memory,
and the developer has to find highly non-C ways to program for a computer like this.
We don't yet have cross-platform SIMD standardized in a C-like way:
either we call SIMD intrinsics or we write the code using concepts like array operations,
which are considered high-level in C programming and are replaced by loops,
and if a C-like code is to be accelerated by SIMD,
we have to pray that the compiler is able to recognize loops that are essentially array operations.

We can see the general problem here: C is not really a cross-platform assembly language
but it's also not a good abstract machine language.
It's a compromise of the two, making it not good enough in either role.
Despite all these, mainstream modern CPUs keep exposing a C-ish abstract machine,
and as GPUs can be conceived as watered down CPUs forming a huge cluster,
GPU development based on C is also not hard.
Radically non-C processors that need a completely different mindset to program are possible and do exist,
but they are never mainstream.
We will discuss this topic [later](#c-works-but-not-well).

# Modern architecture

Following what are mentioned above, we get a computer that has no functionality deficiency.
But it's slow.
We can optimize both the data flow and the control flow using a combination
of approaches listed below.

## Cache

Modern CPU's ALUs are fast.
What is slow is fetching data from the memory.
Therefore it's a good idea to make some ultrafast memories within the CPU,
which, as a compromise, are much smaller in size. 

## Parallelism: an overview

There is a hierarchy of possible parallelism schemes.
We can 

TODO: SIMD in general; SIMD like SSE or AVX; vector machines; streamlining

# GPUs

The theoretical model of modern GPUs are not that different from the theoretical model of CPUs.
The main difference lays in the instruction set architecture
(a CPU core can do much more than a GPU core)
and the number of cores is much higher.

## Streaming multiprocessors

In Nvidia's GPUs, usually 32 cores are organized into one 32-core processing block
which shares a program counter,
and 2 or 4 such groups are organized into one streaming multiprocessors (SM).
A SM also has a shared memory which allows threads running in the same SM communicate very fast.
There is also a L1 cache in each SM, as well as possible specialized units.
Note that the fact that cores in a processing block shares a program counter
already means we should avoid writing too many `if-else` blocks in GPU programming,
as that means if different threads in the same processing block jump to different branches
in an if-else block,
the most natural way to handle the situation is to stop some threads and 
let other threads finish their branch first.
This clearly reduces the speed.

## Threads running on SMs

What is said above is about the hardware architecture of GPUs.
Now we introduce a programming model pertaining to that kind of architecture.

In CUDA, threads are organized into thread blocks.
A thread block is to be run on one SM.
This may let one wonder if the best practice is to make the size of a thread block 128 or 64,
so that a core corresponds to one thread at a time.
The answer, surprisingly, is no:
GPU cores support hyperthreading,
which means a GPU core enables very fast context switching between threads
to fully utilize all resources in the core.
For example, when a thread is waiting to fetch some data from memory,
an instruction from another thread can be run to keep the core busy.
Therefore although for each thread we have a significant latency,
the latency is well *distributed* to all threads
and is therefore hidden from the user if a large number of threads are launched.
The result is that a thread block can be as large as 512 or 1024.

A thread block runs on a SM.
If the number of thread blocks launched in a CUDA program is larger than the number of SMs
(which is not unlikely for large scale computations),
then the thread blocks are executed *wave by wave*.

## Graphic units in GPUs

Note that GPUs were originally for graphic processing only.
A GPU may be designed for scientific computing only,
which only contains the computational cores,
while a truly graphic GPU contains specialized graphic units.
These units are to make the rendering pipeline faster,
aiming to replace time-consuming steps of the rendering pipeline.

The rendering pipeline is 

# Languages for HPC

## C works, but not well

One point we can make is that the modern hardware, after all,
isn't *that* different from an imaginary hardware (basically, a faster PDP-11) that fits perfectly with the abstract machine of C,
and the deviation of a modern processor from a physical implementation of the abstract machine of C
can usually be summarized as acceleration of certain commonly appearing code snippets.
Want to avoid branch prediction failures by conditional moves?
We can add a pragma to a `if` statement while still keeping the abstract semantics invariant.
Want SIMD but do not want to call the SIMD intrinsics? 
Add a pragma to a `for` statement (we, for example, have `#pragma GCC ivdep` now in GCC).
One thing that makes Rust code easy to optimize is that there is much more no-aliasing hints,
but since no aliasing behaviors are just a subset of aliasing-enabled behaviors,
even this can in theory be handled by pragmas.

Another problem of C-style programming is about abstraction.
The only way to use code in C is to define functions.
If these functions modify the variables passed to them - say, when the function is a sorting function,
the idiomatic way is to pass the variables as pointers.
If this is to be taken literally,
then after compilation, the function becomes a segment in the binary executable
which is called by pushing the pointers into a stack and then jumping to its start.
But sometimes, inlining the function might be a better choice.
In C++ sorting can be done by 
```C++
std::sort(vec.begin(), vec.end(), [](int a, int b) {
    return a > b;
});
```
This isn't semantically quite different from 
```C
void qsort(void *base, size_t nmemb, size_t size, 
           int (*compar)(const void *, const void *));
```
but consider this: the compiler is not so sure what `compar` is at compile-time.
Are you, as the chief designer of your project,
100% sure that nothing changes what `compar` you're going to pass to `qsort` before you do the `qsort` call?
On the other hand, in the C++ version, the comparing function is given as a literal so optimization is possible.
Still this in theory can also be solved by giving some hints to the compiler.

We have seen that with pragmas, C code can indeed utilize possibilities of optimization
provided by modern processors.
Still, arbitrarily adding these pragmas to an existing C code base
will likely result in undefined behaviors, as some of the code is not written in a way
that falls within the range where these optimizations are supposed to work.
This can be handled by letting the compiler do more static analysis,
which eventually means creating a new dialect of C,
which is almost as complicated as designing a new language,
which is still C-like overall 
whose idiomatic programming styles however should be highly optimizable.
Rust, for example, is mostly C-like apart from its expressive type system,
but it eliminates a lot of possibilities of aliasing,
and it doesn't encourage users to play with bare pointers.
Therefore the compiler can freely rearrange the order of fields in a struct
or do very radical optimization based on the non-aliasing information.
