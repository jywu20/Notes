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
so they are also managed by PCIe.

One thing particular about disks is that the 

## Virtual memory

## Operating systems

An *operation system (OS)* makes things easier for writing programs.
It registers all drivers during initialization
and also manages the page table for the virtual memory mechanism.

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
we have to expect the compiler to be able to recognize loops that are essentially array operations.

We can see the general problem here: C is not really a cross-platform assembly language
but it's also not a good abstract machine language.
It's a compromise of the two, making it not good enough in either role.
Despite all these, mainstream modern CPUs keep exposing a C-ish abstract machine,
and as GPUs can be conceived as watered down CPUs forming a huge cluster,
GPU development based on C is also not hard.


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

In Nvidia's GPUs, usually 32 cores are organized into one 32-core processing block
which shares a program counter,
and 2 or 4 such groups are organized into one streaming multiprocessors (SM).
A SM also has a shared memory which allows threads running in the same SM communicate very fast.
There is also a L1 cache in each SM, as well as possible specialized units.
Note that the fact that cores in a processing block shares a program counter
already means we need to take a different approach in GPU programming,
as that means if different threads in the same processing block jump to different branches
in an if-else block,
the most natural way to handle the situation is to stop some threads and 
let other threads finish their branch first.
This clearly reduces the speed.

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
If the number of thread blocks is larger than the number of SMs,
then the thread blocks are executed wave by wave.