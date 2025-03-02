[Here](c语言.md) and [here](llvm.md) we have seen that programming languages
which are to be compiled to native code on modern computers
are usually C-like because of the von Neumann-like architecture of modern computers:
the assembly languages can largely be understood in the von Neumann framework,
although for better performances,
techniques like caching, instruction level parallelism, pipelining, branch prediction, register renaming
means the internal structure of a modern CPU looks much more complicated than
the naive von Neumann architecture.

Most modern programmers therefore have a linear perception of the history of programming languages:
first we have von Neumann machines, and then we have early barely high-level languages
that are low-level abstractions over the native code,
and then we have C-like languages.
The true history of early developments of programming languages is much more complicated.

# Earliest attempts: before ENIAC and all that

The earliest computer programs were designed by Charles Babbage and Ada Lovelace.
What exactly counts as a *program* is inherently not clear
(do calculator strikes count as programs?),
and the roles Babbage and Lovelace respectively played in designing the architecture of the Analytical Engine
and programs running on it are not completely clear,
but conventionally, Ada Lovelace is credited for writing the first program in the world,
which is discussed in details in her [Notes](https://www.fourmilab.ch/babbage/sketch.html) on a paper written by L. F. Menabrea introducing Babbage's Analytical Engine.
In the famous Note G in these comments,
a diagram of an algorithm that computes the $n$th Bernoulli's number.

## The programming model of Analytical Engine

The programming model is strikingly modern.
A program is a list of *operation cards*
(operations are known as cards because they were recorded on punched cards).
They are executed one by one by the *Mill*,
and they read and write *Variable Cards* (i.e. memory addresses), which form the *Store* (i.e. memory).
An operation card contains the operation to be done and variables involved.

Lovelace called loops cycles: she correctly noted that for generic computing,
loops are needed and are sometimes to be embedded into one another:

> Wherever a general term exists, there will be a recurring group of operations, as in the above example. Both for brevity and for distinctness, a recurring group is called a cycle. A cycle of operations, then, must be understood to signify any set of operations which is repeated more than once. It is equally a cycle, whether it be repeated twice only, or an indefinite number of times; for it is the fact of a repetition occurring at all that constitutes it such. In many cases of analysis there is a recurring group of one or more cycles; that is, a cycle of a cycle, or a cycle of cycles.

What makes the programming model of the Analytical Engine unlike modern assembly languages
is that there is no `jmp`:
instead, operations that are to be repeated are explicitly grouped by braces.
This is shown in the program given in Note G:
operations 13-16 form a loop, and operations 17-20 form a loop,
and operations 13-23 form a loop that contains the former two loops.

## Ada's insights

Ada Lovelace appeared to be quite insightful of what will happen one century after her.
She noted that 

> It is desirable to guard against the possibility of exaggerated ideas that might arise as to the powers of the Analytical Engine. In considering any new subject, there is frequently a tendency, first, to overrate what we find to be already interesting or remarkable; and, secondly, by a sort of natural reaction, to undervalue the true state of the case, when we do discover that our notions have surpassed those that were really tenable.

and 

> The Analytical Engine has no pretensions whatever to originate anything. It can do whatever we know how to order it to perform…. Its province is to assist us in making available what we are already acquainted with.

The second paragraph is the reason why programming is still a job nowadays.
Her comments also contain paragraphs that may naturally appear in a textbook about structured programming.
Here is a sentence that's particularly educational for scientific programmers writing unmaintainable Fortran programs:

> It is desirable in all calculations so to arrange the processes, that the offices performed by the Variables may be as uniform and fixed as possible.

The primary purpose of the Analytical Engine was numerical computation.
Lovelace however noted that 

> Again, it might act upon other things besides number, were objects found whose mutual fundamental relations could be expressed by those of the abstract science of operations, and which should be also susceptible of adaptations to the action of the operating notation and mechanism of the engine. Supposing, for instance, that the fundamental relations of pitched sounds in the science of harmony and of musical composition were susceptible of such expression and adaptations, the engine might compose elaborate and scientific pieces of music of any degree of complexity or extent.

A decent prediction of what computers do nowadays.

## What Babbage did

Since Babbage initiated the Analytical Engine project,
he had to have written programs on his own.
Ada Lovelace appeared to be an expositor,
who went over Babbage's plan and distilled the overall points.
Babbage didn't publish some of his drafts on how the Analytical Engine should be made,
which also contain [some computations](https://writings.stephenwolfram.com/2015/12/untangling-the-tale-of-ada-lovelace/),
like a computation of the coefficients in the product of two polynomials,
or how division can be implemented.
But none of these has the clear, "modern" flavor of Lovelace's [Notes](https://www.fourmilab.ch/babbage/sketch.html),
to which references were made in Babbage's autobiography whenever the abstract operation of the Analytical Engine was concerned.
Further, it appears to be that Babbage never explicitly mentioned loops,
which are important for generic computing.
It seems that the division of labor between hardware engineers and software engineers was already there in 1840s,
especially considering Babbage developed a complicated [Mechanical Notation](https://writings.stephenwolfram.com/2015/12/untangling-the-tale-of-ada-lovelace/) in his sketches of the design of the Analytical Engine.

## Influences on modern computer science

Unfortunately, the Analytical Engine was never successfully made,
and even in the 1960s Babbage and Lovelace weren't known for their works.

# Early hardwares and their influences to early programming languages

Now we turn to early computers that were actually made.
[ENIAC](https://en.wikipedia.org/wiki/ENIAC) was not a von Neumann machine. It was programmed by rewiring, which makes it FPGA-like and was only later turned into a stored-program computer (which eliminated its ability of parallel computation).

Most of the early computers were von Neumann machines.
The only one with a remarkably different architecture probably 
was [ORDVAC](https://en.wikipedia.org/wiki/ORDVAC),
which was von Neumann but was asynchronous.

If for some reason, the FPGA-like architecture had persisted,
[Verilog-like languages](../Circuit/HDL.md) would have appeared much earlier.
In this world, however, the architectures and instruction sets of most early computers
weren't drastically different from modern ones.
The first "high-level" programming languages that actually got implemented on real machines
expectedly all targeting  von Neumann architectures.
[The Early Development of Programming Languages by D.E. Knuth](https://www.club.cc.cmu.edu/~ajo/disseminate/STAN-CS-76-562_EarlyDevelPgmgLang_Aug76.pdf) 
is a good summary of the early history of programming languages.

# Esoteric high-level languages

Von Neumann's flowchart was attempted to represent algorithms in a straightforward way
but turned out to be very esoteric.
In this graphic language, `i-1 -> i` is *not* a computation (calculating the value of `i-1` and then storing it into `i`),
but a change in notation: the memory is not disturbed after the statement.

Zuse in Germany developed a language known as Plankalkül or "Plancalculus".
Plancalculus had a quite advanced feature:
hierarchically structured data down to the bit level.
Other early programming languages didn't care about data structures.
Other aspects of the language are quite confusing for a modern programmer.
A statement *obligatorily* takes several lines:
the first line is the main body of the statement,
the second line, labeled as "V", specifies the subscripts of the variables.
Thus variable `a0` and `a1` are represented by 
```
A
0
```
and 
```
A
1
```
respectively. Element getting, like `a[0]`, is performed by a third line, labeled as "K":
thus 
```
V
0
i
```
means `V0[i]`.
Finally, a fourth line specifies the type of each variable.
This notation is extremely cumbersome but a mathematically fluent user at that time would probably like it.
Suppose we are trying to evaluating $f(x, y)$ where $x$ is already given.
We can write 
```
f
x
y
```
where `x` is to be replaced by its given value.
There is no `if` statement, but we do have conditional assignment.
There is a for loop block.
The naming convention of Plancalculus is also extremely weird:
`AΔ1` means floating-point number, and `A9` means integer.
The ideas of the language however is truly remarkable:
the language is strongly typed, supports structured programming only,
and have hierarchically organized data types.

A follow-up of Plancalculus was Rutishauser's Superplan.
It doesn't even contain conditional assignment:
conditional assignment is implemented by, say,
`condition × expr1 + (1 - condition) × expr2 → var`.
The only flow control block it contains is the `for` loop.
The language was designed for an imaginary machine.

Curry designed his own programming language,
which was also an early attempt of structural programming,
but the notation was also awkward.
Assignment is written as $\{ \text{expression}: \text{variable} \}$,
and sequential execution is written as $\{ \text{block 1} \} \to \{ \text{block 2} \}$.
These seem reasonable;
but then he introduced labels of entrances and exits in the control flow
and conditional jumps to utilize these entrances and exits.
So we have `goto`, basically, and labels are split into entrances and exits.
Further segments of programs can be named and embedded into other segments:
some sort of COBOL `paragraph`.

Bohm designed a machine and a programming language that only contains assignments:
flow control is done by assigning to the program counter.
What's remarkable was he achieved bootstrapping,
having written a compiler in his own programming language.

Languages discussed here were all early attempts to 
abstract away from the hardware details.
Among the languages discussed here,
Plancalculus is probably the most semantically non-esoteric and the most syntactically esoteric.
Regardless of whether they were appropriately designed,
none of them had compilers or interpreters.

# More practical languages in the US

Meanwhile in the United States,
a series of programming languages that are still close to the bare metal were designed.
They generally lack modern `if` or `while` blocks.

Short Code was designed to be interpreted.
It looks not very different from assembly languages,
but supports writing long expressions like 
`y = (√ abs t) + 5 cube t`.
Note that each symbol in the expression above is to be replaced by 
two alphanumeric characters,
and a program eventually looks like a matrix of alphanumeric characters.
In some senses this is comparable to how Scratch works.

Grace Hopper advocated that high-level languages should be not interpreted:
they should be compiled.
Her first compiler, `A0` was closer to macro expansion today.
A successor to `A0`, `A2`, compiles something similar to Short Code into native code.
She organized two symposia on compiled languages,
on which Laning and Zierler presented a text-based language that can be compiled,
which looks not very different from the text form of Short Code
but accepts arbitrarily long algebraic expressions.
One esoteric feature is it allows subscripting, in the format of `a|i`.
There is also a built-in Runge-Kutta mechanism.

The earliest Fortran language was inspired by Laning and Zierler's language.
Here *arrays* were introduced, by the `dimension` statement that's still in use today:
```Fortran
  DIMENSION A(11)
  READ A
2 DO 3, 88, J=1,11 
3 I=11-J
...
```
Control flows were still not structured.

From the first day, compiled languages were met with skepticism about their speeds.
This was the case when Fortran was widely publicized.
After years of iterations and optimization,
we eventually have Fortran I,
which, besides all necessary parts that make it suitable for generic computation,
also was the first to have comment lines and exit codes.

Parallel to the development of Fortran,
Grace Hopper herself and her group developed MATH-MATIC and FLOW-MATIC,
two languages that were very verbose but at least human-readable.
The programming model of MATH-MATIC is basically the same as that of Fortran.
FLOW-MATIC's most famous successor is COBOL.

# Going towards the world we're familiar with

Hierarchical data structures, structured control flows, and recursion were still lacking in these early, "practical" languages.
But they will appear quite soon.
In ALGOL 60, code blocks were first introduced, which are defined by the `begin`-`end` pairs,
and recursion was added at the last minute.
We still only had arrays and no other composite data types.
This array-oriented mindset reminds us of how Fortran (regardless of the versions) works.
Structs and unions were not a part of Algol 60, but was later introduced in 
CPL (a language inspired by Algol 60) and then in Algol 68.
Algol 68 turned to be too complicated to implement and to learn,
and later derivations like BCPL (from which C originated) and Pascal emerged.

Fortran underwent several updates and some now obsolete features
like the `common` block, the `equivalence` statement and the Hollerith constants were introduced.
In Fortran 77, block `if` and loops were eventually introduced,
as well as the `character` type.
It was not until Fortran 90 that derived types (i.e. structs) and official support for recursion were added to Fortran.
(This is why old Fortran functions and subroutines have long, long parameter lists.)
Modern Fortran is not far from the C family,
and a LLVM-based compiler for Fortran is now available.
Note that certain optimization changes guaranteed by Fortran's semantics can't be realized
by LLVM backends because the information is lost in lowering Fortran code to LLVM IR.
(For example, the information that certain operations are on arrays or complex numbers,
or the strict aliasing rules.)
This can be done by adding more attributes in LLVM IR,
or by [doing the optimization *before* lowering to LLVM IR](https://fortran-lang.discourse.group/t/c-is-not-a-low-level-language/2464/6).

The development of COBOL is much more eccentric.
COBOL's fate of being isolated from the mainstream computer science community
(unlike Fortran, which is a regular player in high performance computing
and is in the C-like ecosystem)
was probably determined the minute it was designed.
Structured `if` blocks and the `perform ... until` construct
were included in the first COBOL report,
so structured programming was possible from the beginning.
But the fact that branches and loops are not treated equally 
probably has already told us that the language was designed by extracting common design patterns from assembly programs 
(you need a label to write a loop in assembly,
and indeed you need a paragraph label to write a loop using `perform ... until`),
and not by systematic designing.
After that COBOL was gradually standardized but few modern features were added to it.
It was not until 2002 that COBOL received a major update,
when object-oriented features, user-defined functions, recursion, pointers, allocation and freeing, etc. were added into COBOL.
Still developers are reluctant to use these features,
as the idiomatic way to write COBOL hasn't changed for quite a while.

We can even argue that before COBOL 2002, the language specification is not Turing complete,
because the memory available to the program has been pre-determined by the data division,
and therefore a program is bound to fail for an input large enough.
Of course, any physical computer is not Turing complete in the same sense;
by saying that a computer is Turing complete what we actually mean is that 
in theory we can give more and more RAM to it
without changing the programs it runs.
(In practice, of course, when the address space exceeds the 64bit memory limit
we'll have to update the instruction set architecture and recompile all programs,
but it's more a technical detail as programmers typically
don't make their programs strongly depend on the size of the address space.)
So in theory we can create a big, big array in the data division as the memory pool.
In practice though people just bear with it.
For instance, the absence of any dynamic memory allocation means that in COBOL we will not have big integers,
so we need to be [very careful whenever truncations happen](https://www.reddit.com/r/ProgrammingLanguages/comments/t3w03g/comment/hyvxxoh/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button).

Nowadays COBOL almost only runs on IBM z mainframes.
This makes COBOL look almost like a domain specific language:
we define abstract "forms" (as in a business setting) in the `DATA` division,
and use built-in file IO statements to fill these forms,
and then print them out.
The lack of dynamic allocation means COBOL programs don't need heaps.
Moreover, frequently, COBOL programs lack recursion and 
even do not have real subroutines (`paragraph`s and `section`s are used instead),
so there is no need for a *stack*.
These make executables compiled from COBOL fast, and also secure.
Almost like a better structured assembly language.
This probably is comparable to Structured Text in PLC programming.

The two languages originating from the first ten years of modern computing,
COBOL and Fortran, are more or less domain specific in today's perspective.
And they are rightly so because the tendency back then was to design languages
targeting a specific audience.
It's like embedding a library into a language:
in Fortran, it's having a good linear algebra library in the language.
Modern languages, despite being much more generic,
may still have "built-in libraries", just like Go having goroutines.
