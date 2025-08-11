Hardware description
==========

This note is carried out in a round-by-round way,
starting from *high level synthesis* (HLS),
i.e. converting ordinary programs into circuit logic.
Therefore it may appear not so organized at the first glance,
and should be read as a whole.
We start by having a very brief overview of basic principles of digital circuit designing,
and then, as all computable functions can be implemented in structured procedural programming,
compare digital circuit designing and structured procedural programming,
highlighting the fact that digital circuits can easily implement all elements in structured procedural programming
but has a memory cutoff.
This line of thinking eventually leads us to high-level synthesis,
but we first discuss an easier version of programming-like digital design,
namely register transfer level (RTL),
and then introduce Verilog, a commonly used RTL hardware description language (HDL).
Finally, we go back to HLS,
and discuss how software concepts like functions, streaming, multithreading
inform hardware designing. 

# General ideas of digital circuit designing

Designing a digital circuit is very different from programming in the ordinary sense.
In ordinary programming, the procedure to be done is really stored somewhere in the memory,
and the CPU runs the instructions one by one
(see [here](../HPC/overview.md#von-neumann-architecture)).
A generic digital circuit doesn't run "instructions" "one by one":
it just receives signals from the input ports and
then by the laws of semiconductor physics,
generates some other signals at the output ports.

The internal structure of a digital circuit, in principle, can vary wildly;
but usually we restrict ourselves to what we usually understand as circuits,
i.e. things made of wires, logic gates, flip-flops, etc.
Designing of digital circuits is to arrange these components.
Best practices of arranging these components essentially become a physics-independent field:
that's not uncommon in science, as we can build different systems with the same fundamental physics
but we can also realize the same behaviors with very different low-level physics.
For example we can utilize the way we design digital circuits to design a Turing machine in a Life Game.
The only difference is this is probably not the most natural way to do things in Life Game,
but this is the most natural way to do things with digital circuits components we already have. 

Gates give us *combinational logic*:
they are hardware implementations of pure functions.
Unlike the case in software programming, however, with what we understand as digital circuits,
we can't easily do functional programming.
The easiest way to have Turing-complete behavior is to use things like flip-flops as registers,
and the nature of components means designing digital circuits is closer to procedure programming,
where we have variables and assignments.
(Of course, circuits are finite and are therefore never truly Turing complete,
but we can make our design very generic so that by increasing the number of registers without significantly rewiring everything
we can have more and more complicated behaviors,
and this is Turing completeness in practice;
on the other hand combinational logic is never Turing complete even in this sense:
to have more complicated behaviors, we need to not only increase the number of gates
but also to non-trivially wire them.) 

The main difference between generic digital circuit designing and procedure programming, still,
is we don't have a programmer counter to keep track of what thing to do:
the physics of electronic components means they run in parallel by default.
This may lead to asynchronous problems:
suppose we need to read from two registers,
but we're not sure when they get their values from two upstream circuits.
Often, we group together a part of the circuit and use a clock to synchronize their behaviors.
Such a group usually takes the form of a combinational logic block that can read from a memory block,
the memory block in turn receiving assignments from the combinational logic block
to make sure when the variables change, they change at the same time
(this is what a flip-flop does:
for its content to change, we need an enable signal).

# Digital circuits compared with structured programming

We already know that digital circuit designing is kind of similar to procedural programming but has differences.
Here we make a comparison between the two,
or, in other words, see how procedures well-described by structured programming
are *synthesized* into digital circuits.
We use the term "synthesis" and not "compilation",
because the distance between a physical hardware design and a procedural algorithm
is arguably much larger than the distance between a procedural algorithm and its assembly language compilation:
it's still possible to say "these lines of assembly code corresponds to this line of C",
but it's generally hard to say what exactly a line of Verilog or HLS C compiles into:
whether an `else` branch of a `if` block exists may decide 
if a variable is synthesized as a latch or a flip-flop, for instance 
(see [here](#always_-blocks)).
The ideas developed in this section are related to both [RTL](#register-transfer-level-rtl-description)
and [high-level synthesis (HLS)](#high-level-synthesis-hls).

Sequential execution of a finite list of statements
is in theory always implementable within the regime of combinational logic
(in practice we may want to break them into several stages,
and a stage variable, essentially a program counter, keeps track of the current stage:
the reasons are discussed [here](#keep-the-circuit-in-mind)),
provided that the variables are not accessed by other blocks of code.
We may have things like `temp = a; a = b, b = temp`,
but we can always routinely eliminates the intermediate variables
and get a mapping from the initial values of `a` and `b`
to the final values of `a` and `b`.
Of course, if `a` and `b` are visited by other segments of programs,
we need registers to hold their values,
but still the sequential part would be minimal.

When a sequential logic block is too long,
there is another way to implement it:
breaking it down into several stages
and use a state variable to guide the execution of these stages.
As is discussed below,
*this* is the most generic way to encode control flows in digital designing.
Correspondingly, the aforementioned way to implement sequential execution
is actually *instruction-level parallelism* of sequential execution.
This mismatch between the term "sequential structure" in procedural programming and in HDLs (discussed later in this note)
needs to be noticed:
"sequential" or "procedural" blocks in HDLs usually should be kept short
(see [here](#keep-the-circuit-in-mind)),
and are subject to various parallelism mechanisms which from the perspective of software engineering are instruction-level parallelism,
while sequential blocks in procedural programming languages can be arbitrarily long
and instruction-level parallelism often can only focus on a part of a long sequential block.

Similarly, the if-else structure, if without loops inside,
can be routinely implemented with combinational logic
plus some sequential parts for bookkeeping of the values of the variables.

Loops are generally hard to handle in digital circuit designing,
because it strongly depends on things like program counter,
the most straightforward implementation of which needs statements to really be stored somewhere.
If the upper bound of a loop is known,
it can be synthesized by repeating the loop body for several times.
If the upper bound of the loop is not known,
or if the upper bound of the loop depends on the input,
then the loop is not directly synthesizable.
But note that in theory, a program only needs one infinite loop,
and we already have a loop going on forever in sequential logic
because the circuit is periodically synchronized by the clock
(in theory the semantics of an unbounded loop can also be handled by various asynchronous mechanisms).
This means we can implement loop conditions of the aforementioned unbounded loops as registers,
update their values in each clock cycle,
and decide what to do in this clock cycle depending on the values of the registers,
effectively deciding whether to keep doing the loop body
or to jump out of the loop.
(Often, though, even when theoretically the loop is unbounded,
in practice we will have a bound above which the problem is not feasible anyway
with the existing resources,
and in hardware design a bounded loop can then be used.)
This is where sequential logic becomes non-trivial.

In theory we can use a fast clock and a slow clock
to implement two embedded loops.
This however is rarely done in reality.

In summary, the best way to turn a procedural code into digital circuits
is to first divide the algorithm into code blocks
and assign a stage index to each of them,
and then rewrite unbounded loops into a single large loop,
the loop body of which takes the form of 
```Verilog
case (stage)
    STAGE_0: begin
        // Combinational logic, register assignments
        stage <= next_stage;
    end
    STAGE_1: begin
        // Combinational logic, register assignments
        stage <= next_stage;
    end
end case 
```
and then it should be easy to automatically synthesize.
What we're doing here is actually to extract the *control flow* structure of the algorithm
into a finite stage machine,
the state transfer of which is controlled by other variables (data flow),
and `stage` is essentially the program counter,
and `stage <= ...` corresponds to jump statements.
At each state of the finite state machine,
certain operations - the code segment corresponding to the value of the state variable - are done.
Note that because actual hardwares are finite in size,
the algorithm has a resource cutoff and [itself becomes a finite state machine](#turing-completeness),
but this finite state machine is much larger than the finite state machine representing the control flow.

So now we have seen that just using assignments to registers in clocked circuits,
we can turn all procedural programs into hardware logic,
following the procedure of cutting the program into pieces 
and then use a finite state machine to handle the control flow between the pieces.
We can do this transform manually,
and describe the algorithm in terms of [register transfer level (RTL)](#register-transfer-level-rtl-description).
After discussing the general ideas of RTL,
we will dive into Verilog, a quite popular HDL,
whose semantics we find is actually quite close to 
[a computational graph together with a lot of event listeners](#summary-of-semantics-of-verilog).
We can also use [C-to-RTL tools, or in other words high-level synthesis (HLS)](#high-level-synthesis-hls) to automatically convert procedural codes into RTL.
HLS compiles C/C++ functions into RTL modules,
and therefore more subtleties like how to ensure the correct control flow between two functions arise.

# Register transfer level (RTL) description

The variant of procedural programming that works on the concept of state machines and is sketched in the last section
in which we have assignments and combinational logic
is known as register transfer level (RTL) description.
The meaning of the name is self-explained;
one thing we need to note however is that the registers mentioned in RTL
are not always physical registers:
here the term *register* is an abstract, semantic concept, 
and it's probably better to call them variables,
as they are abstract entities that, depending on whether their values need to be kept
for the use of the next clock cycle,
are sometimes realized as physical registers and sometimes just some wires.
This distinction reminds us of how stateful programming is modeled in functional programming languages like Haskell;
the implication of this is discussed [here](#functional-programming-in-circuit-designing).
After synthesis a register may be a flip-flop, a latch, or simply a wire if it has no stateful behaviors.

RTL is the theoretical basis of many hardware description languages (HDLs).
Currently the most important HDLs are VHDL and Verilog.

Below RTL, we have gate level and even transistor level descriptions;
above RTL, we have behavioral and algorithmic levels.
These levels all have alternatives:
we don't really need to use transistors to make gates,
and we can compute without what's typically understood as gates (as in, say, some neuromorphic platforms),
and in principle if we have components that can keep a piece of information for a given period of time,
registers are not "truly" necessary and we don't need "register transfer" in this case,
and even when we need register transfer, we can use a paradigm that deviates from typical RTL languages
(see the discussions on functional programming below; we also have thiings like transaction level modeling (TLM)),
and whether there is an absolute standard for "high-level"-ness is also problematic.
Nonetheless, we're dealing with engineering and not physics here,
and exploration of alternative possibilities is not the top priority
unless you're in the R&D department of a major fab who finds it's impossible to have 0.5nm techniques
or someone discovers an important algorithm that almost can't be expressed in terms of RTL with a reasonable amount of effort.

## RTL as event-driven programming model and as hardware description

RTL description can be seen as a programming model.
If we're sure that the physical circuits components faithfully implement
any RTL logic we'd like to have,
then simulation of RTL descriptions involves *no* semiconductor physics:
it's just *executing* the RTL statements just like how Python code gets executed.
Therefore we may talk about how HDL statements get executed:
this is a *semantic* and *behavioral* concept,
while the intended usage of HDL codes is to describe what a digital circuit should do,
where there are physically no statement stored somewhere.

Note that the state machine model, and therefore RTL HDLs based on it,
is not restricted to synchronous circuits,
because in this model the clock signal is merely yet another signal coming into the circuit,
and what makes a signal a clock signal is merely the fact that in the design of the circuit,
sequential logic is controlled by the signal
(as in e.g. `always` block in Verilog).
In this way a RTL HDLs code is just like a web server programmer:
it gets called whenever some sort of request (passed as an ordinary argument) comes in.
The only difference it has with a server software is that 
as is said above, loop control is combined into a part of request handling.

## Turing completeness

RTL is Turing complete in the sense that
there is no theoretical bound to the total size of the registers:
thus to handle more and more complicated problems,
we can just increase the total size of the registers without changing anything else in the code.
And as long as all bounds are properly defined,
we have the same random access ability in C:
deciding which address to visit according to an input signal is pretty synthesizable.
Loops are treated in the same way.
If, however, we consider the result of synthesizing,
"merely" changing the upper bounds in the code does change a lot of the circuit structure.
Without the bounds in mind, RTL is Turing complete,
and with the bounds in mind, RTL describes finite state machines.
(Note that very often when we talk about finite state machine in RTL,
we're talking about a finite state machine that controls the stage of computation,
or in other words, the control flow:
see [here](#digital-circuits-compared-with-structured-programming)).

By the way, [C itself faces a similar problem](https://cs.stackexchange.com/questions/60965/is-c-actually-turing-complete),
which in one aspect is more severe and in another aspect is less severe.

Let's start with the more severe aspect.
in C, memory addresses are accessed directly by dereferencing pointers,
which means the address space is always limited by the upper limit of the pointer type.
To access a theoretically infinite memory space, we need big integers,
which are implementable in C but cannot be dereferenced.
Adding more memory typically means to add more RAM.
However, eventually the total RAM will hit the upper bound of the pointer type:
for example a 32 bit system can't use more than 4GB of memory.
So here it seems that C has a *hard* memory upper bound,
which cannot be passed unless eventually we have to migrate to systems with larger pointer sizes.
Note that in C we can't declare arbitrarily large number types that can be integrated into  the pointer semantics;
in Verilog it seems [no such limit exists in simulation](https://electronics.stackexchange.com/questions/705776/is-there-any-restriction-on-the-maximum-size-of-a-systemverilog-packed-array)
(although it of course exists in the hardware platform in question).

At the C source code level, cross-platform-ness with respect to the pointer size
can be achieved by avoid mentioning the size of a pointer
and always write `type *p` and avoid converting a pointer to a number,
and if the latter is necessary, write `intptr_t number_corresponding_to_ptr = (intptr_t)p;`.
This makes sure the source code doesn't need to be modified when we upgrade the system.
Still the assembly code after compilation can be quite different.
Cross-platform-ness is lesser a problem for more high-level languages like Java,
where dynamic memory allocation involves no direct play with pointers.
So we may say that C (or even better, Java) is Turing complete in the sense that
there is no theoretical bound to the total size of the memory the programs can use
(and C now is as Turing complete as RTL),
but the assembly code is not.

Still, assembly code is somehow closer to being Turing complete in the sense that 
memory constraints aren't something that we think of all the time,
and the way dynamic memory allocation works, despite having a upper bound,
is still quite close to how unbounded dynamic memory allocation works.
So this is the less severe part:
the structures of 32 bit and 64 bit assembly code are largely comparable,
but the structures of two circuits corresponding to the same RTL code 
but with different memory sizes can be very different if we focus on the local structure.

In this sense we can have the following hierarchy of Turing completeness in practice:

1. The real thing: the mathematical definition of Turing machine or random access machine,
   and also languages like Lisp or ML or even Java that doesn't face that fact that 
   pointers in real world computers are bounded.
   A variant of C that supports infinitely large integers used as pointers also belongs to this class.
2. The family of languages in which the only thing that blocks Turing completeness is the memory upper bound, which however can be arbitrarily large.
   In this family we have RTL with a large memory pool (whose size is defined as a constant which can be adjusted on demand by the coder),
   and also languages like COBOL or Structured Text (for PLC programming) with a large memory pool, 
   and C code where the pointer size is always represented by `intptr_t`.
   The above RTL and COBOL coding styles however are more or less awkward.
   The C coding style above is not awkward but many just don't care this type of cross-platform practices.
3. The family of languages in which the memory upper bound is a given constant.
   We have arrived at the class of finite state machines, actually,
   but if the memory is large enough then for small tasks,
   we can still say that the programming model is Turing complete
   because the semantics of dynamic memory allocation resembles the semantics of dynamic memory allocation in the class above (though some differences exist in practice, for instance the heap and the stack often grow in opposite directions, which only makes sense when the memory space is finite).
   This is the position of idiomatic C.
   We can do the same for the "large memory pool" coding styles mentioned above
   and implement memory allocation and freeing functions in the memory pool (that can no longer be infinitely expanded at compilation).
4. The family of languages in which all types of dynamic memory allocations are discouraged.
   Programming using these languages is just programming finite state machines in a more organized way.
   This class includes (idiomatic) RTL, Structured Text, COBOL.
   Still, occasionally, people may (unintendedly) write programs that are actually in the third class above (or even in the second class above, with the upper bounds of arrays and pointers (if any) carefully defined as constants).
   Therefore, users often do not realize that the idiomatic way to write these languages are actually not Turing complete in any sense.
    

## Functional programming in circuit designing

By refraining from using highly procedural-like constructs in RTL,
we will find a paradigm that is quite close to functional programming,
and thus we find that RTL as we know it is of course not the only theoretically possible way to describe hardwares
without touching directly the gates but still in an easily synthesizable manner.
(Although we can still call it RTL, as usually we will still see some sort of registers;
otherwise we'll call it a kind of high-level synthesis).

The combinational logic part of a synchronous circuit is basically a state transfer function:
it looks quite similar to the `>>=` operator of a Haskell `Monad` like `IO` or `ST`.
The Verilog `always` block can then be seen as a `do` block,
which ultimately boils down to combination of stateless functions.
Assignment statement in this `do` block either changes the state (as in `return` in Haskell),
or does not (as in `let ... = ...` in Haskell, which is just aliasing),
and in the latter case they are in theory not necessary.
Let's reflect for a while about what's being done here:
it seems what's being described here is actually one (quite neat) way to understand
how to synthesis assignment statements.
As is said above, explicit loops in RTL have to be bounded.
This originates from the fact that loops are usually synthesized by unrolling,
and since the size of the circuit is limited,
loops have to be bounded.
In Haskell `Monad`s, a loop block is just a function
and takes the form of `whileM_ :: Monad m => m Bool -> m a -> m ()`,
and bounding a loop is equivalent to imposing some limits on how many recursions are possible.

The result is a description paradigm that in some aspects are closer to how the hardware actually works:
intermediate variables, for example, are strictly distinguished from actual registers.
So we can see the difference between high-level and low-level descriptions is sometimes hard to tell:
people will tell you that functional programming is high-level,
but here functional programming is closer to the low-level description in some sense.
We can then increase the level of abstraction by the usual ways in functional programming.
There has been attempts to do this: see e.g. https://clash-lang.org/documentation/.
For discussions on how to use the Monad-like perspective to design sequential logic,
see https://clash-lang.readthedocs.io/en/latest/developing-hardware/prelude.html#state-machines.

Despite the alternative formalisms, conventional RTL, which works on concepts like variables and assignments, is still the first choice of almost all developers at least for now.
Several factors may explain this.
First, compared with C, it's likely that hardware engineers are even less familiar with functional programming.
For example, loops, which for "resource reasons" needs to be bounded,
are much more intuitive than recursion, and creates less surprises.
Second, the simple `do` block-based scheme sketched above
defines the state transfer function of a circuit as a whole,
but sometimes we like to separate the state transfer function into several sub-blocks
for better readability.
In procedural programming-like HDLs,
we can write several event-response blocks that naturally share registers,
just like how in real procedural programming,
we write several event handlers that run in parallel but share global states.
In functional programming this is less straightforward,
although not completely infeasible:
we can for example split the combinational logic into several pure functions
and then use these pure functions in the `do` block that defines the state transfer operations,
and leave all register assignment statements in the `do` block.
This may even be considered as good practice,
since it efficiently removes data race.
But this can also make the code less intuitive.

## Unsynthesizable behavioral descriptions

Since the concepts of RTL description are somehow close (though still different in significant ways) 
to procedural programming,
it seems a good idea to after all include procedural programming concepts into HDLs.
This is known as *behavioral* descriptions
because now we directly describe the algorithm to be implemented
in a straightforward and hence "high-level" way
(although there is no good definition of the meaning of being high-level,
as we have already seen above).
These "high-level" descriptions need to be broken down to RTL descriptions in order to be synthesized,
although a programmer familiar with procedural programming
may instead say that the state machine model is truly high-level.
Once we have procedural programming, object-oriented programming and more seem natural.
Therefore a large portion of Verilog is *not* synthesizable:
they're there just for behavioral description, that's to say, for testing only.

We need to add a quick comment about the criteria of being synthesizable.
Of course, nothing is truly non-synthesizable,
as we have already shown [here](#digital-circuits-compared-with-structured-programming)
that all algorithms can be implemented in digital circuits.
What makes a construct not synthesizable *in the sense of RTL* is 
the impossibility to synthesize it in a compositional way.
A `always` block in Verilog, introduced below, is synthesizable at the level of RTL,
because it corresponds to a certain circuit module which contains some flip-flops
and is connected to the clock signal, no more, no less,
and if we have two `always` blocks, the synthesis results of them has nothing different from 
the simple combination of the two `always` block synthesized separately.
A generic procedural algorithm, on the other hand, is not synthesizable in this sense:
if we put two procedures together,
the synthesis result is *not* the same as the combination of the two procedures synthesized separately
because we need to change the structure of the finite state machine.
(Of course, we can also use handshake signals etc. but this also leads to area overhead -
see [here](#hls-synthesizes-functions) and [here](#sequential-relation-between-function-calls).)

So that's the difference between synthesis of RTL and synthesis of generic procedural algorithms:
synthesis of RTL is very *localized*:
changes of a line of Verilog code usually don't result in very limited changes to the gate circuit.
This is the difference between RTL synthesis and high-level synthesis that synthesizes a generic procedural algorithm.
Below, we discuss the two one by one.

# Synthesizable building blocks of Verilog

Verilog is a widely used HDL.
It's truly like a software programming language,
in which we don't have direct access to concepts like gates or physical registers
(in Verilog, the term "register" refers to abstract objects that keep the values they are assigned with;
as is said above, registers or variables in Verilog may be synthesized as actual physical registers i.e. flip-flops or memory blocks,
or just as some wires coming out of some gates
when actually they do not affect the state of the next clock period).

## Organizing the code 

What is supposed to represent a circuit is a *module* in Verilog.
In it, we declare wires and (logical, not necessarily physical) registers
and their behaviors.
By default statements in a module are run in parallel,
because circuits do run in parallel.
We have procedural blocks to enforce (semantic) procedural execution within them,
like `always` or `begin end`.

Besides modules we also have *functions*,
which represent combinational logics that can be reused in different blocks.

A module can be conceived as a class as in object-oriented programming,
to some degree.
An instance of a module has private fields, namely the registers in it,
which keep the state of the object,
and public fields, namely the wires connected to it.
Assignments to the public fields trigger setter methods
(handled by [event listeners](#event-listener)),
which may also change the internal state of the object.
To avoid race conditions, it's a good idea to make the variables governed by a module have clear "purposes":
some are for inputs and some are for outputs.
The `inout` purpose is also available.
This line of thinking can actually be used to design another family of hardware description languages in competition with standard RTL.
HLS platforms currently available however are more based on *functions*
and functions launched as threads, and not module-as-objects
(see [here](#high-level-synthesis-hls)).

## Event listener

The `always` block is used to register event listeners.
The event being listened to is always the change of a value.
Thus we may write `always @ (a) begin ... end`
or `always @ (posedge a) begin ... end`.
The event being listened to is called the *sensitivity list*.

When the sensitivity list is `@(*)`,
any changes to variables that are read in the `always` block are listened to.

Note that from the semantics of event listening,
it's not impossible that two event listeners are triggered at the same time,
and possible data race will appear between the two.
Verilog's semantics is inherently concurrent,
because hardware is indeed concurrent:
two event listeners are just two sub-circuits connected to the same wire
that expresses the "event",
and of course they run in parallel.

One thing worth noticing is that `@(...)` itself is a legit expression in Verilog:
it just means "wait until ...".
So `always @ (posedge a) begin ... end` is actually
```Verilog
always
    @ (posedge)
    begin
        // ...
    end
```
If we want to use non-synthesizable Verilog, we can also use `@` in the following way:
```Verilog
initial begin
    @(posedge clk);
    // ...
end
```
this means to wait until `clk` increases,
and then do the following operations.
The code snippet above won't synthesize.

## Assignments: continuous

Assignments in Verilog can be divided into continuous assignments
and assignments with the same semantics in ordinary procedural programming.
The latter requires sequential logic, as is discussed below.
Continuous assignments, on the other hand,
are semantically constraints between variables:
if a continuous assignment `a = b + c` is made,
then whenever `b` and `c` changes, `a` changes as well.

What's happening here is quite close what we do in algebra:
we may say "suppose we have variables $a$ and $b$, and we define $c = a + b$". 
Unlike assignment in procedural programming,
the relation $c = a + b$ is always right.
What's being done here is actually function composition:
so-called "variables" are functions defined on an unknown "state space",
and by saying $c = a + b$,
we're actually saying that $c$ is defined such that $c(s) = a(s) + b(s)$.

In a digital circuit, the states in the state space are signals loaded to the ports,
and $a$ and $b$ are either wires directed connected to the ports,
or wires coming from logical gates connected to these ports.
And by writing `c = a + b`, we are just connecting $a$ and $b$ to an adder, whose output is connected to wire $c$.
This is how a continuous assignment gets synthesized.

Since continuous assignments semantically are function composition
and practically always result in new wires and not new registers,
in Verilog we have a `wire` keyword to hold the output of continuous assignments.

From the perspective of software engineering,
continuous assignments create a computational graph.
We can view a computational graph as a composite function.
Another perspective, which is less algebra-like but more consistent with the intuition of software engineers,
is to view it as an event handler:
whenever an assignment to one of the variable involved in the computational graph is detected,
the event handler is invoked and updates the values of variables.
This is exactly the semantics of the `always_comb` block in Verilog
(or its earlier version, `always@(*)`).

The advantage of the event-driving perspective is that it captures
what happens when we have feedback loops.
In the following code 
```Verilog
module sr_latch(sb, rb, q, qb);
    input sb, rb;
    output q, qb;

    nand(q, sb, qb);
    nand(qb, rb, q);
endmodule
```
the last two statements instantiate two nand gates,
which is equivalent to continuous assignment to `q` and `qb` of `sb` nand `qb` and `rb` nand `q`.
The behavior of the feedback loop seems uncertain if we view the code as a computational graph.
If, instead, we view the two continuous assignment statements as two `always@(*)` event listeners,
then what happens is clear:
if an external assignment of `sb` to 1 happens, then the first event listener is triggered, and if `qb` currently is 0,
then `q` gets assigned to 1.
This in turn triggers the second event listener,
and if `rb` is current 1 then `qb` becomes 0.
Now the second event listener triggers no value change, so no further event listening is needed, and the simulation continues to the next event.
The procedure sketched here is exactly how a SR-latch works.

## Assignments in sequential logic

Now we consider assignments in sequential logic,
whose semantics is close to assignments in procedural programming.
They are therefore known as *procedural assignments*.

Since the values of registers don't really change until this clock cycle ends,
we actually have *both* the new value and the old value available for each register:
the old value can be read from the register,
while the new value can be read after some gate circuits.
So it seems that reading the *old* value is sometimes more straightforward
in terms of synthesis.

In Verilog, we have *blocking assignment* and *non-blocking assignment*.
The terms are kind of misleading: *immediate and deferred assignment* seem to be better terms.
In simulations, the former takes effect immediately,
which means that after `a = ...`,
whenever we read `a`, we are reading the new value,
while the latter takes effect after this `always` block,
which means when we read `a` after `a <= ...` we're reading the old value.
This sometimes makes programming easier:
swapping two variables now is as simple as `a <= b; b <= a`.
In synthesizing, block assignment is often used for intermediate variables (see below),
while non-blocking assignment is often used for physical registers,
because non-blocking assignment is closer to how flip-flops work:
to synthesize 
```Verilog
always @ (posedge clk) begin
    a <= some_external_input;
    b <= func1(a);
    c <= func2(b);
end
```
we can just add three registers corresponding to `a`, `b` and `c`,
and connect `some_external_input` to the input of `a`,
and connect the output of `a` to `func1`, the output of `b` to `func2`,
and wire the outputs of `func1` and `func2` accordingly to the output of `b` and `c`:
when a clock cycle starts, the output of a register will not immediately change,
and therefore what get passed to `func1` and `func2` are all old values,
therefore the synthesis result is consistent with the semantics of `<=`.
On the other hand, in 
```Verilog
always @ (posedge clk) begin
    a = some_external_input;
    b = func1(a);
    c = func2(b);
end
```
we *cannot* wire the output of `a` to `func1`,
because if this is the case, what `func1` gets is the old value of `a`.
So we have to wire `some_external_input` to `func1`.
Similarly in the synthesis of `c = func2(b)`,
because the appearance of `b` corresponds to the new value,
we should then connect the output of `func1` directly to `func2`.

The last code block can be rewritten into
```Verilog
always @ (posedge clk) begin
    a_new = some_external_input;
    b_new = func1(a_new);
    c_new = func2(b_new);

    a <= some_external_input;
    b <= b_new;
    c <= c_new;
end
```
The first three lines are blocking assignments,
but as the data flows in and out of `a_new`, `b_new` and `c_new` all happen within one `always` block,
the final synthesis result of the assignments is essentially combinational logic 
and can be replaced by continuous assignments outside the `always` block.
Importantly, the registers `a_new`, `b_new` and `c_new` actually are *not* synthesized into physical registers.
That's way blocking assignments are often used only for intermediate results:
their semantics, when important to the sequential behaviors, need some hack to implement with actual hardware,
but as intermediate variables, they actually represent *combinational wiring*.
Another way - a more hardware-oriented way - to see this is to notice that 
according to the discussion above, after a statement `a_new = ...`, when `a_new` appears,
it's the `...` expression that gets directly wired to the follow-up logic,
so `a_new`, if implemented as a physical register,
is just a register recording the result of `...` at each clock cycle,
which however is never read,
so it can be removed.

The intermediate blocking assignments, as is mentioned above, are just combinational logic,
so in principle they can be moved out of the `always` block.
Suppose we have a `c <= a + b` non-blocking assignment in an `always` block.
It's sequential logic,
but the `a + b` part actually can be replaced by a wire that comes from a continuous assignment outside the `always` block.
So instead we may write a continuous assignment `assign c_w = a + b` outside the `always` block,
and then write `c <= c_w` in the `always` block.
This is how any assignment with an expression on the right hand side, like `c <= a + b`, is synthesized.

When an input to the module - say `a` - is volatile,
meaning that the way it changes cannot be simulated by any circuit logic in the current module
(for example, it may change within one clock cycle),
we can see the difference between procedural assignment and continuous assignment most clearly:
a continuous assignment `b = func(a)` makes `b` volatile as well,
but a procedural assignment `b = func(a)` records the value of `func(a)`
and then `b` and `a` are detached from each other:
the value of `b` only changes when the next procedural assignment comes.
After synthesis the procedural assignment `b = func(a)` results in a register
placed after the output wire of `func(a)` that "blocks" the volatile change of `a`.

## `always_` blocks

As is said [here](#assignments-continuous),
we can also understand continuous assignments as procedural assignments
in event listeners listening to the change of `a`.
In this understanding, there is no substantial difference between continuous and sequential assignments.
The semantics and hence synthesis results can be inferred from how the body of the `always` block is written.

If a `always @(*)` block contains only combinational logic,
it's equivalent to continuous assignment statements.
If, however, we have branching statements that leave a variable to its old value in some situations, as in
```Verilog
always @ (*) begin
    if (state == READY) intermediate = func(input);
end
```
then `intermediate` is synthesized as a *latch*:
its assignment can happen at *any* time, as long as `state` becomes `READY`.
In synchronous circuits, however, latches, even intended, make timing difficult because assignments can happen at any time:
as soon as the value of `input` changes
(maybe at a certain time step in one clock cycle),
the value of `intermediate` changes,
which makes risks of race conditions much higher.
In asynchronous design methodologies latches are important.
In clocked design methodologies, the main use of latches seems to be *making* flip-flops;
latches however can be useful in advanced optimization techniques like time borrowing.

In SystemVerilog, we have three additional `always` blocks:
`always_comb`, which is basically `always @(*)` that requires its content to be pure combinational logic;
`always_latch`, which makes clear that registers in it are to be synthesized as latches;
finally `always_ff`, which makes clear that registers in it are to be synthesized as flip-flops,
and therefore reports an error when its body contains no sequential logic.

## Branches and loops

We have already outlined how to treat branches and loops [here](#digital-circuits-compared-with-structured-programming).
We note that `if` blocks and `for` blocks with bounds are to be used in `always_` blocks,
as they can be reduced to combinational logic.
Unbounded `for` and `while` should always be transformed to finite state machines first,
or, when high-level synthesis is available, the transformation can be done [automatically](#how-loops-are-implemented).

Besides `for` in event listeners,
in software engineering, `for` can also be used to register even listeners.
In RTL designing, clearly, event listeners can't be dynamically registered,
and this means synthesizable `for` loops should be bounded as well
(and they should also appear *outsides* `always_` blocks).
Verilog distinguishes `for` loops (in event listeners)
and `generate for` loops that launch event listeners (and hence also modules).

## Summary of semantics of Verilog 

The existence of procedural assignment statements to Verilog variables
make the variables look like variables in procedural programming.
The existence of continuous assignments and `always` block,
however, makes them look like *tensors* in computational graphs in e.g. PyTorch,
assignments to nodes in which may automatically be forwarded to update values of other nodes
or trigger events that are then handled by parallel event listeners.
This kind of automatic forwarding can also be seen as a part of event handling:
whenever an assignment happens, some values are updated
in this way we can understand Verilog purely as an event-driven language.
Indeed, recently `always_comb` is added to Verilog 
for description of continuous assignments in a more event-driven style.
The functionality of calling a method on an object
is replaced by sending a signal (i.e. assigning to a certain variable) to a module.

If regarded as a programming language, Verilog is thoroughly event-driven,
and in each event listener we have finite procedural programming
(unbounded loops have to be implemented by event-driven features),
while different event listeners run in parallel,
and independent statements in one event listener also run in parallel.
All variables are like tensors in a deep learning framework because of continuous assignment,
and we have natural constraints forbidding assignment to non-terminal nodes in the computational graph.
Event listeners and variables they share are organized into modules,
and event triggering is as simple as assignment to the input ports of a module.
A module can be instantiated in another module,
in the same way a neural network module is instantiated in a bigger network.

It can be seen that several paradigms that are traditionally considered as high-level - 
event listening, computational graph,
and parallelism whenever possible from the structure of the computational graph - 
are integrated parts of Verilog,
which however is generally considered a low-level description.
So again, the high-level/low-level distinction is theoretically not always a well-defined concept.
Moreover, Verilog puts these things together in a largely well-integrated way,
unlike languages like C++.

Despite this theoretical simplicity,
since when writing down an algorithm, human beings thinks not in terms of 
computational graphs or event listening
but in terms of e.g. procedural programming,
which has to be converted into state machines in Verilog
(see the end of [here](#digital-circuits-compared-with-structured-programming)),
Verilog codes in actual projects often involve boilerplates
and understanding what they are actually doing is often hard.

There is one important counterexample of the statement "human beings think in terms of procedural algorithms":
the semantics of synchronous RTL is almost identical to *ladder diagrams* in programmable controller (PLC) programming.
Unbounded loops can be added into ladder diagrams but usually in a slightly awkward way 
(attaching a label between two rungs, and then add a jump command to one rung).
Control engineers seem satisfied by ladder logic,
so at least for some tasks, people are literally going to think in circuits!
This in turn means that PLCs now are defined by how they are programmed,
and although PLCs are traditionally made of CPUs,
it's possible to program FPGAs with ladder diagrams,
essentially turning a FPGA into a PLC.
This is done for example in https://onlinelibrary.wiley.com/doi/10.1155/2022/8827417.
(There however is one caveat: ladder logic can be seen as *relay logic*
if we ignore the side effect caused by assignments,
and relay logic is different from transistor logic:
in relay logic 0 and 1 are represented by current levels,
while in transistor logic 0 and 1 are replaced by voltages.
Therefore in relay logic we have serious fan-out problems,
as making copies of a signal requires non-trivial designs like a signal regeneration stage,
which accepts the weakened signal and provides a fresh, full-strength current for the next stage.
So although the semantics of ladder diagrams can be transparently translated to RTL,
the diagram itself is *not* the digital circuit diagram corresponding to the RTL.)

## Keep the circuit in mind

People often say that when writing Verilog,
it's necessary to think of the circuit you're designing,
and not just the algorithm.
One reason to say this is of course due to the unique semantics of Verilog,
and you simple will not be able to write Verilog as if you were writing C.

Moreover, despite the programming paradigm of Verilog containing some high-level concepts,
Verilog in practice is quite low-level in the sense that
issues *beyond* the formal semantics that are directly related to the circuit after synthesis are important when writing Verilog.

First, circuit components have latency,
because it takes time for signals to propagate.
In physics the mechanisms behind latency is interesting,
while in digital circuit designing we usually just consider latency as something to bear with,
but regardless of how you see it, latency is there,
which means if a `always` block is too complex,
it probably will not finish in time before the next clock cycle comes,
and the correct semantics is that the `always` block gets run again,
leading to race conditions.
Timing is of primary importance in hardware design.

When a `always` block is too complicated to finish in a clock cycle
we have to options.
We either make the clock cycle longer,
or break the combinational logic in the `alway` block into several stages,
each of which finishes within one clock cycle,
and the output of each stage is stored in certain registers,
and then set up a state variable that goes like stage 0, stage 1, stage 2, stage 3, ..., stage 0, stage 1, stage 2, stage 3, ...,
and the module only talks to the outside world when the state of the system is at stage 0.
Thus an `always` block that takes too long to finish, like this:
```Verilog
always @ (posedge clk) begin
    a = func1(external_input);
    b = func2(a);
    c = func3(b);
    output_wire = c;
end
```
is replaced by 
```Verilog
always @ (posedge clk) begin
    case (state) 
        STAGE_0: begin
            stage <= STAGE_1;
            a <= func1(external_input);
        end
        STAGE_1: begin
            stage <= STAGE_2;
            b <= func2(a);
        end
        STAGE_2: begin
            stage <= STAGE_3;
            c <= func3(b);
        end
        STAGE_3: begin
            stage <= STAGE_0;
            output_wire <= c;
        end
    endcase
end
```
provided that `func1`, `func2` and `func3` all finish within one clock cycle.
`external_input` is only read when the module is at `STAGE_0`:
otherwise it's just ignored.

On interesting question would be why don't we just ignore the clock altogether and use a busy flag (basically, a simplified version of `stage`) that gets set to true when an external input arrives,
which then prevents the module from accepting external input until the task finishes,
and let the combinational logic in the module run, ignoring the clock.
In theory we of course can. However there are some problems.
The first problem is the combinational logic doesn't really "know" when it finishes (it's just a complicated semiconductor device with a funny stimulus-response curve),
so some additional mechanisms are needed.
If the total time cost of the combinational logic is known,
that we still need a `stage` variable to keep an eye on the beats ("0...1...3...4... - the combinational logic should already be finished right now"),
and using registers to keep intermediate results makes the circuit more robust.
If the total time cost of the combinational logic is *not* known
(when, for example, we have unbounded loops),
then each component with a determined time cost of the computation needs a timer that notifies the next stage that the results are ready (and complicated handshaking protocols),
and we're in the regime of asynchronous circuit designing.
The conclusion is that within the synchronous circuit designing methodology,
breaking a long calculation into stages and use a `stage` variable to keep track of the current stage is desirable. 
The `stage` variable is essentially the program counter here.
Note that in synchronous circuits we also need handshake signals if the combinational logic takes more than one clock cycle to finish:
this corresponds to how `return` is implemented in structural programming,
[and is related to HLS](#sequential-relation-between-function-calls).

A problem that used to be serious but now has eased is coding style greatly influencing the structure of the synthesized circuit.
If the synthesizer can't optimize the code well,
we can't just write Verilog code however we'd like.
By using the same type of optimization techniques in software engineering,
the situation has been improved, but there are still incidents where the way Verilog is written causes congestion,
meaning that there isn't enough room to put all the wires.

# The physical target of synthesis

We have seen that actual circuits have delays,
and the question is how the delays are modeled.
This urges us to go back to physics.

## The physics of circuits: general ideas, $L$ and $C$

Here we have a brief overview of classical electronics.
The term "classical" here means the system shows no quantum coherence:
it's not necessarily due to "inherent" $\hbar \to 0$ conditions in the system
(for example when $S^2$ is large),
but due to environmental bathing:
electron currents in ordinary circuits are constantly being "observed" by various dephasing factors in the wires, like thermal phonons,
and quantum coherence, in most of the time, can be ignored.

Because of the strong dephasing,
the theory of classical electronics is not quite different from the electromagnetic version of hydrodynamics.
In hydrodynamics, we assume that thermal fluctuations render pure-state bosonic excitations irrelevant,
and the flow of conserved quantities become relevant because the conservation laws are still satisfied even after thermalization.
In electronics we also assume that electronic degrees of freedom other than the charge and the current are not relevant.
Therefore just like in hydrodynamics we only care about forces and fluid flow,
in electronics we only care about voltage and current.
This hydrodynamic approach can be comprehended as a specific case of quantum non-equilibrium physics
(see e.g. https://arxiv.org/pdf/2203.10110.pdf; also note that the term "hydrodynamics" means different things to different people: here it means kinetic theory of non-equilibrium systems based on a handful of conservation laws, but it may also mean bosonization of systems into quantum Euler equation, or writing the single-particle Schrodinger equation into a hydrodynamics-like form),
but in practice this is usually not how we do it.

Note that the idea that only the currents matter when describing the state of an electronic device
does *not* deny that other degrees of freedom exist in how the current responds to the electric field:
for example, the $U$-$V$ property of a component may originate from exciton formation.
What we're doing here include several things.
First, we assume that multi-electron correlation doesn't exist,
and the dynamics of the system can be described as something like time-dependent adiabatic GW (TD-aGW),
a single-electron quantum master equation where the single-electron energy has self-energy corrections.
Second, we assume that quantum coherence, like coherent excitons
(corresponding to non-diagonal components of the single-electron density matrix,
which originate from $\ket{\text{ground}} + c \ket{\text{excitation}}$ after perturbation),
serves as intermediate steps in the dynamics of currents
(just like how $\rho_{\text{eg}}$ matrix elements in Bloch equation are non-zero
so probability transfer from $\rho_{\text{gg}}$ to $\rho_{\text{ee}}$ can happen),
but because of the existence of dephasing, non-diagonal components of the single-electron density matrix never appear in observables.
Third, for quantities like $f(\vb{k}, n, n') c^\dagger_{n \vb{k}} c_{n' \vb{k}}$,
we assume that as long as they are not the current or the charge,
they do not matter because as is said above, thermalization will not keep these quantities stable.

What we have is now a formalism that works only on $\vb{j}$ and $\vb{E}$ and sometimes $\vb{B}$.
To make designing and maintenance easier,
it's often further assumed that we're working with *circuits*,
so that currents run on wires and the electric field is replaced by the voltage between two nodes in the circuit.
The internal structures of components are regarded as black boxes.
This sometimes breaks down: we for example have mutual inductance.
When things like mutual inductances and parasitic capacitance are considered,
components that can be easily captured with isotropic electrodynamics in medium
(hence $\vb{j} = \sigma \vb{E}$ where $\sigma$ is a scalar)
can usually be simulated as effective networks of $LCR$ circuits
because this is just discretization of electrodynamics with the displacement current term ignored
(although treatment of things like Hall conductance can be cumbersome).

As a constructive proof, suppose we discretize space into a cubic lattice,
and place a charge variable at each vertex.
The charge variable should be equal to $\int_{\text{cube around this vertex}} q \dd^3\vb{r}$.
The current can then be defined on the six surfaces of the cube containing the vertex,
and therefore we can place a current variable as well as $U = \int \dd{\vb{l}} \cdot \vb{E}$ at each edge.
Note that Maxwell equations only involve first-order spatial derivative operators
(if we eliminate $\vb{B}$ then we have $\nabla \times \nabla \times$,
but the effects of the magnetic field are included by calculating $\vb{B}$ directly and calculate the inductance electric field using the mutual inductance matrix):
therefore we can represent $E_{x,y,z}$ by the three voltages on the $+x$, $+y$, $+z$ surfaces,
and all the Maxwell's equations can be turned into equations about a single cube.
From the second and the fourth Maxwell's equation, we know the solenoidal part is given by $\partial_t \vb{j}$,
and the mapping from $\dot{I}$ at each edge to the solenoidal contribution to $U$ at each edge
is represented by a giant mutual conductance matrix.
The capacitor part, i.e. the divergent part, seems more complicated in theory because electrostatics is complicated.
But we can always use $q = \oint_S \dd{\vb{S}} \cdot \vb{E}$ and put $S$ around the node,
and as the only $\vb{E}$ component that contributes to the integral
is the component that's perpendicular to the surface of the cube containing the vertex,
the RHS of the equation can be completely determined by $U$,
and thus we find we can effectively say there are six capacitors connected to the vertex,
each of which connects the vertex to a nearest neighbor.
(Although the capacitor model describes the divergent part of the electric field,
as long as the mutual inductance matrix is defined correctly,
using the divergent part of the electric field or the whole electric field to calculate $\int \dd{\vb{S}} \cdot \vb{E}$ shouldn't lead to different results.)
So then we can place the capacitor and the inductor in serial and place the resistance in parallel with the two at each edge,
and thus we get a discretized version of displacement current-free (that's to say, near field) electrodynamics.
By using the common circuit simplification techniques,
for simple structures (like a transmission line)
we can greatly simplify the corresponding effective circuit.

Systems whose behaviors strongly depend on the dynamics in the medium, like diodes,
have to be simulated using solid state physics formalisms like TD-aGW
because as is said above, to explain the internal mechanisms,
quantum coherence becomes important.


## The physics of circuits: $R$

Resistance comes from all kind of mechanisms:
electron-electron scattering, electron-phonon scattering, electron-impurity scattering.
And even when we only have $L$ and $C$,
we still find that an infinite transmission line looks just like a resistance.
In a word, resistance comes from coupling to an environment that's much larger than the system.

Resistances tend to be linear.
This is like how a laser medium emits light to the outside world 
or a quantum dot connected to two ports is modeled:
by Markovian approximation, we write the coupling of electromagnetic fields in the system 
and electromagnetic fields in the environment 
as a $1 / \tau$ term,
but this is just a part of the input-output formalism
and doesn't mean there is anything inherently thermalized in the system.
For example consider radiation resistance: the antenna may first capture a signal and then emit it,
and in the whole process no energy goes to degrees of freedom that are not explicitly accounted for.
Thermalization only happens when we explicitly dictate that
a port in the input-output formalism is thermalized,
which, as is said above, is true in ordinary electronics.
Indeed in the infinite transmission line model of resistance,
we also need to explicitly assume that all modes in the transmission line are thermalized.

The fact that $U$ and $I$ have such a simple relation is, from the perspective of physics, astonishing.
We can apply an electric field to the sample and measure the current response,
but suppose we somehow manage to create some currents in the sample,
Ohm's law tells us that there *has to be* an electric field whose magnitude is given by $IR/d$.
That's to say, there is no other variable hidden in the sample in determining the relation between $I$ and $U$.
The reason why 

## The physics of circuits: diodes

The $U$-$I$ relation of a diode is often derived using Fermi golden rule.
Note that we don't need to account for states like $(\ket{\text{left}} + \ket{\text{right}}) / \sqrt{2}$:
they deviate too far from the preferred basis of these dephasing processes.
A theory of the behavior of a diode in a circuit has to be a rate equation, then.

## Combinational logic in digital circuits

What makes digital circuits quite different from circuits made of (linear or non-linear) $L, R, C$ circuits
is that when there are no feedback loops,
that's to say, when we only have combinational logic in the circuit
(sequential logic can also be implemented using logic gates,
but this always requires feedback loops: see the next section),
the simulation of the circuit is quite *local*.
If somehow we already know the voltages of the input wires of a component,
then the output voltage is straightforwardly given;
on the other hand, in a $RLC$ circuit,
knowing the voltages of the input wires is not enough:
we need also to know the current going through the circuit,
which is given by the voltage on the circuit,
i.e. the voltage *difference* of the input and output wires.
Therefore the simulation of a $RLC$ circuit is always kind of non-local,
while the simulation of a digital circuit is very local.
In a combinational logic circuit,
as long as the input voltages are given,
we can successively calculate the output voltages of each component,
just like [how a computational graph is evaluated](#summary-of-semantics-of-verilog).

This is partly due to the separation between power and signal in digital circuits:
the same high voltage line and low voltage line are connected to every logic gate,
and the "input" voltage just controls whether the output wire is connected to the high voltage line or the low voltage line.

We need to note that although digital circuits are often conceived as networks of controlled switches,
they still cost energy to run.
Even if the wires have zero conductance, the voltage of a register turning from low to high involves energy cost like the $CQ^2/2$ in capacitor charging.
(In the case of a capacitor, the fact that the voltage on the capacitor grows from 0 to $CQ$ while the external voltage applied to the whole device is a constant $CQ$
meas that there has to be some sort of $R$ in the system that takes the rest of the voltage:
it can be ordinary resistance or radiation resistance,
but it has to be some sort of resistance.
Also note that in theory, the electromagnetic wave radiated in radiation resistance is not necessarily thermalized.
This is related to the concept of reversible computing,
in which as no information is discarded, zero heat generation is possible.)

## Stateful objects in digital circuits

By connecting output wires of some components back to the input wires,
we can create multiple stationary states,
and which state the system is in depends on the history of its interaction with the environment.
It's under this general idea that we have *latches*.
A latch has two stationary states, and which state it's in can be told from the signals on the output wires.

This multi-stationary state nature of latches distinguish them from ordinary combinational logic.

Two latches can be used to make a flip-flop.

## The generic circuit: FPGA

CPU is an architecture to generically implement "programs".
As is said above, digital circuits implement RTL "computational graph".
Digital circuits are more flexible - sometimes too flexible,
and we'd like something that can emulate any other circuits,
executing a RTL "computational graph" just like a CPU executing instructions.
There are many ways to do this (and these solutions are known as programmable logic devices, PLD),
and the most important one currently is known as
field programmable gate array (FPGA).

There are two aspects important to understand FPGA:
the first is its hardware design,
and the second is how RTL is translated into how these gates are programed.

FPGA, as a circuit, is a grid of lookup tables (LUTs),
routing tracks, and switchboxes.
LUTs are linked to the routing tracks in a programmable way:
whether a LUT is linked to a routing track (and if so, which one)
is controlled by a bit stored in e.g. a flip flop.
The switch boxes link routing tracks together, again in a programmable way,
controlling how tracks in two beams of routing tracks connected to the switch box
are linked to each other.

A LUT can emulate any logic gate with a given number of input wires:
therefore it is actually a RAM,
with the truth table of the gate being the data stored in the block
and the input wires specifying the address to the data to be output.
We may also want to specify whether the output of the LUT should be stored in a flip-flop.
This can be done by linking the output wire of the LUT memory to two branches,
one being a simple wire and the other being a flip-flop,
and the two wires are then linked to a multiplexer,
which is controlled by the output of another flip-flop.
The second flip-flop receives a signal that controls whether the output of the whole thing
comes from the simple wire or the flip-flop.
The LUT, together with the two flip-flops and the multiplexer, is called a programmable logic block.

So now, by connecting the LUT memory and the flip-flop controlling the multiplexer,
we can program the LUT into an arbitrary logic gate,
with or without its output buffered in a flip-flop.
Now we want to know if this kind of architecture can indeed emulate all digital circuits.
For synchronous circuits, this is theoretically trivially true.
First, as is mentioned [here](#always_-blocks),
any synchronous digital design eventually boils down to combinational blocks separated by flip-flops,
and flip-flops are one-in, one-out objects,
so it's not possible that two flip-flops are connected directly by some wires.
Therefore for a combinational block with some flip-flops following it,
we can always break the combinational block into intertwined LUTs,
and the flip-flops are then attached to the nearest LUTs,
and in this way we have converted the circuit into logic blocks connected together.
Then, by programming the routing tracks and switch boxes,
we can easily connect two arbitrary logic blocks,
and now we show that in theory any synchronous circuit can be implemented by a FPGA.

Latches can also be synthesized in FPGAs because a latch can be made of logic gates with feedback loops.
It's generally not encouraged to do so however,
because of the possible timing problems and increased power cost.
Moreover, it's generally not recommended to do anything asynchronous on FPGAs.
All tools targeting FPGA assume your design is synchronous,
and doing asynchronous designing on FPGAs wastes the clock on the chip.

In actual designing,
a major problem will be whether there are enough tracks for routing,
and there is in general no guarantee that a large circuit can be emulated before we run out of tracks.
The FPGA architecture, after all, is designed to maximize the resources that can be placed on the chip,
not to make hardware development for it easy.
If we indeed run out of tracks,
we say we encounter a *routing congestion*.
Note that it's quite likely that before we truly run out of tracks,
timing violations already appear because it takes too long for a signal
to propagate to where it should go to in one clock cycle.
Solutions include manual floor planning
and rewriting the RTL code.
The general idea is to make the RTL as localized as possible:
therefore a variable is not to be fanned out i.e. passed around infinitely,
complex logic should be broken into small modules,
and long `case` blocks should be somewhat simplified.
These are of course also good ideas for software engineering in general,
but in FPGA programming they have physical consequences.

Actual FPGAs contain further components,
including block RAMs (BRAMs), DSP blocks, and also IO blocks connected to the tracks.
They can all be invoked by the programmable gate array.

# High-level synthesis (HLS)

Although as is mentioned above, the abstract semantics of RTL 
is based on event listening,
an unfortunate fact is that we human programmers never think in this kind of formalism
when designing algorithms.
It's still desirable to design hardwares using standard procedural programming.
This is known as high-level synthesis (HLS),
where the term "high-level" is more about being close to how we humans understand problems.

## What typically are not supported in HLS

There are several aspects that make HLS hard.
Let's start with the semantics.
The bad news is that event-driven programming can in theory be highly complicated
(think about what happens in a server),
the good news is that in most digital circuits the only "event" is usually just the clock
(plus some handshaking signals - but usually they are not specified in `always @ (...)`,
and instead appear in conditions of `if` blocks
that decide whether to proceed),
so we're basically dealing with a big infinite loop.
The synthesis of a structured procedural program into synchronous RTL therefore
ideally is straightforward,
as is discussed [here](#digital-circuits-compared-with-structured-programming).
We basically extract all the control flows into a finite state machine,
and parts in the computational diagram that are independent to each other
are handled in parallel,
just like how instruction-level parallelism is done.
However, most popular programming languages contain constructs
that make HLS hard, as is discussed immediately below.

C is often known as a somehow low-level language
(the claim itself needs to be taken with a grain of salt:
C has no control over caching, virtual memory, instruction-level parallelism, etc;
but x86 assembly also doesn't have fine-grained control over these:
modern computer science is abstraction all the way down):
this sometimes can be a problem for HLS
because a feature that is low-level to CPUs is sometimes not low-level at all for logic gates.
For example, in C, all functions see the same memory space:
a pointer can be passed around and wherever it is dereferenced,
the same memory address is visited.
In hardware design, however, memory is often distributed:
a module has its internal memories and another module can never visit it.
Therefore if C is to be used for HLS,
anything involving randomly accessing a pointer will be problematic for synthesis.
This includes dynamic memory allocation as well.

On the other hand, languages like Python hide details like memory address from the programmer
and sometimes happen to be *better* than C when it comes to HLS.
For example, a variable used in a function can never be visited by anything out of the function,
because we can't get the address of it and pass it out of the function.
But these languages do rely a lot on dynamic memory allocation, etc.
and therefore also deviate from what can be done in actual hardwares.

There are also features that are supported in almost every ordinary programming language
but are hard to synthesize.
Recursion, due to its nature, is usually not supported in HLS:
in theory any recursion can be rewritten into an unbounded loop,
but this requires a call stack
and usually does not generate optimal hardware design.
Programmers are expected to first mathematically turn a recursive algorithm
into one based on loops.

As is discussed [here](#turing-completeness),
the semantics of RTL has no hard memory bound,
but in practice hardwares always *have* memory bounds
and that's also the case in RTL HDLs.
The memory bound usually is not something we'll encounter in CPU software development,
so we can do `malloc`, etc.,
which essentially boils down to visiting areas in a conceptually infinite memory space.
This is not the case in hardware designing.
Of course, we can always ask for a large memory block
and do memory allocation inside of the memory block,
but that's something to be done explicitly.

The compromise is to pick up a language - usually C or C++ in practice - 
and synthesize only a subset of it,
controlled by pragmas.

## HLS synthesizes functions

HLS typically targets functions, which are natural counterparts of modules in RTL, with some caveats.
The way the synthesis result of a function is supposed to be used is called the interface of the module,
and here we discuss some issues in interface synthesis.
A module synthesized from a C function, embedded in a digital circuit,
can be semantically viewed as a thread running that C function.

The first caveat is that
ordinary functions are supposed to be called in a given order,
and mechanisms ensuring this may be called *block-level interface protocol*.
We can use a handshake protocol to make sure the sequential order is right,
as in [here](#sequential-relation-between-function-calls).
It's also possible to have no time order ensuring mechanism at all:
in this case we need to make sure the input data are given at the correct time and held for enough time,
and that what's supposed to read the output starts to read the output in time.

Some functions are supposed to be run over and over again,
because they are actively reading from input streams and writing to output streams.
In software engineering, they are to be *launched* by some thread launching functions,
the implementation details of which are usually hidden from the user.
In HLS, the interface synthesis of these functions needn't consider any sequential time order insurance,
and the arguments (see below) can only be streams.
An example is given in [the documentation of Vitis](https://docs.amd.com/r/en-US/ug1399-vitis-hls/Data-driven-Task-level-Parallelism).
If in a top-level function we only see thread launching and not ordinary function calls,
the synthesis result will be a giant pipeline:
you put a data stream at one side (the temporal separation between two data points should be long enough)
and you get a steady stream at the other side.

We note that even if a function is not intended to be launched as a thread,
the final synthesis result of a function is supposed to be run over and over again as well.
The point to have explicit primitives that allow us to define threads
that respond to streaming inputs and run over and over again
is to improve compositionality:
otherwise to express the concept that two threads are to be run in parallel,
we have to manually mix their statements together
(and then let the HLS tool to find possibilities of parallelism),
which makes the project unmaintainable.

We further need to know how arguments are synthesized,
that's to say, *port-level interface protocol*.
Different types of arguments,
including [pointers](#pointers), [streams](#streaming),
need different treatments.
Finally we consider the control flow within the function,
including [loops](#how-loops-are-implemented)
and [branches](#how-branches-are-implemented),
as well as [parallelism](#parallelism) that is both important in CPU programs and in HLS.

Besides all signals for control and data flows and their intended usages (i.e. protocols),
we also have the good old clock and reset signals on the interface.

In SystemVerilog we also have functions.
Synthesizable functions in RTL languages are a subset of functions in HLS:
the former are expected to contain combinational logic only
and should finish within one clock cycle,
and there is no need for block-level interface synthesis mentioned above.

## How loops are implemented

As is discussed [here](#digital-circuits-compared-with-structured-programming),
converting a loop to RTL can be hard.

As is said in the link, a bounded loop can in principles be implemented by unrolling.
But this makes the design less area-efficient,
because each iteration now is a submodule.
This does make the computational speed much faster though,
so a balance between speed and area is important.
Usually this means the loop will not be completely unrolled.
In this sense, unbounded loops can also be unrolled.

When iterations of a loop, bounded or unbounded, are independent to each other,
we can do pipelining.
That's to say, suppose we have $N$ operations in each iteration,
and then we can first feed data in iteration 1 to operation 1,
and then feed data in iteration 2 to operation 1
and the output of operation 1 to operation 2,
and so forth.
This kind of design reduces the idle time of the operations,
and can be seen as [a reduced case of multithreading](#parallelism).

We note that here "loops" mean loops in *algorithm designing*.
Loops can also be used to launch threads,
which, according to the basic mechanisms of [high-level synthesis of multithreading](#parallelism),
should always be bounded.
This corresponds to `generate for` loops in Verilog,
which are to be used *outside* `always` blocks
and are used to launch event listeners (see [here](#branches-and-loops)).

## How branches are implemented

`if-else` is theoretically easier than loops,
but it also involves non-trivial analysis in HLS.
The common wisdom is to execute the two branches at the same time,
and then use the condition to pick up one result from the two.
The total time cost of the `if-else` block is the longest of the two branches.
Note that even if one branch is not executed,
we still should expect the worst
and wait until even the most painstaking branch has finished,
or otherwise we're in the risk of timing violation.

## Parallelism

It makes no sense if the RTL generated by HLS is executing one instruction per clock cycle:
in this case we're just reinventing (a rather slow) CPU.
Good RTL has a lot of parallelism.
At the level of RTL, besides parallelism between different event listeners i.e. `always` blocks,
all parallelisms are instruction-level parallelism:
if two code blocks are independent to each other,
then they can be synthesized separately.
In HLS, we can still conceive some parallelism as multithreading.
Multithreading-like parallelism does exist in loop unrolling:
when iterations of a loop are big but largely independent,
after they get unrolled, they're synthesized into identical copies of circuits that run like threads,
though we can also say that this is instruction-level parallelism after loop unrolling.

It's often the case that two independent loops are *not* implemented in parallel,
possibly because if they are to be implemented in parallel,
the resulting state machine will contain too many states.
Vitis HLS provides a "data flow" pragma that enables multitasking.
In [the documentation of Vitis HLS](https://docs.amd.com/r/en-US/ug1399-vitis-hls/Control-driven-Task-level-Parallelism),
this type of parallelism is known as *control-driven task-level parallelism*.

"Full" multithreading or even MPI-like multi-tasking involving data exchange between threads
is also possible but has to be done by additional programming primitives.
An example use case is discussed in with [streaming](#streaming),
and functions that are launched as threads have special [interface synthesis](#hls-synthesizes-functions).
[The documentation of Vitis HLS](https://docs.amd.com/r/en-US/ug1399-vitis-hls/Data-driven-Task-level-Parallelism)
calls this *data-driven task-level parallelism*.

Control-driven task-level parallelism is kind of like OpenMP.
Data-driven task-level parallelism is a restrained version of server development in software engineering,
because we do not have a natural way to end a thread.
If we want threads to formally end,
we can only use the `dataflow` pragma, i.e. control-driven task-level parallelism.
Typically, the function a thread runs looks like this:
```C
void func(hls::stream<int> &in, hls::stream<int> &out) {
    int data = in.read();
    // Do something with data
    out.write(results);
}
```
We note that `in.read()` blocks the execution in its semantics,
and thus what a thread does is like the follows:
```C
while(1) {
    if (/* the stream in is updated */) {
        int data = updated_data;
        // Do something
        out.write(results);
    }
}
```
So the thread goes on over and over again.
But we don't need threads that are launched to end anyway:
what we can do is 
```C
for (i = 0; i < N; i ++) {
    launch_thread(worker_func, input_stream[i], output_stream_merged);
}

for (i = 0; i < number_of_expected_output; i ++) {
    results[i] = output_stream_merged.read();
}
// do something with results
```
From the perspective of software,
after the threads are launched, the second loop is run immediately,
but `output_stream_merged.read()` finishes only when data has been supplied into `output_stream_merged`,
and therefore before the threads finish their jobs (after which they are still running but have nothing left to do) the loop will not finish.
And once the loop finish we to to sequential execution of statements below the second loop.
From the perspective of hardware design,
the function calls `output_stream_merged.read()` are probably synthesized into a module that doesn't set its "finished" signal to true
before `number_of_expected_output` outputs are received
(see [here](#sequential-relation-between-function-calls)).
Anyway, the threads launched do not need to end:
the main function (i.e. the main module) simply stops listening to the worker threads it launches,
the latter not needing to end.

Note that pipelining can be manually described in the format of the first loop:
we can write a pipelined algorithm in HLS 
by launching a thread for each step in the algorithm,
and the synthesis result is just a pipelined circuit.
The main difference between pipelining and the first `for` loop is essentially
that in pipelining we know that each step finishes within one clock cycle,
so the streams can be replaced by simple registers.
(Additional pragmas are needed to make sure the streams are replaced by simple registers.)
The second `for` loop is similar to the "result collector" after a pipeline.

We can also combine the two types of parallelism together.
It's trivially possible to use data-driven task-level parallelism in a control-drive task-level parallelism thread,
and we can also employ the scheme sketched in the last code block
to embed a complicated streaming algorithm into control-drive task-level parallelism,
as is shown [here](https://docs.amd.com/r/en-US/ug1399-vitis-hls/Mixing-Data-Driven-and-Control-Driven-Models).

It should be noted that typical hardware implementations
do not support a very large number of threads.
On a FPGA, for example, [routing congestion will likely happen](#the-generic-circuit-fpga),
because inevitably having a large number of threads
means we need to pass data from a center to these threads,
which requires a lot of wires to implement.

## Pointers

Pointers have to be used to specify output variables
to fit RTL semantics into C semantics:
```C
void do_something(int input1, int *output1) {
    // ...
    *output1 = xxx;
}
```
And `do_something` can then be called in another module to modify some of the internal memories of the latter,
as if we can define addresses for these internal memories.
(We note again that calling `do_something` increases the area of the the module that calls it.)

Apart from this, "real" pointers can be used to visit block RAMs.
Distributed RAMs on the other hand are not supposed to be visited by pointers.

## Volatile variables

Some programs are supposed to be real-time:
that's to say, in an ordinary program,
an argument is not supposed to change within one invokation,
but in a real-time program, because an input variable is attached to some sensor or things like that
or is maintained by a mouse driver or keyboard driver
(the two scenarios are semantically the same), 
or because an output variable is to be set to several different values within one invokation
(to, for example, periodically change what LED gets lightened),
that's no longer the case.
The keyword `volatile` in C is used to label an argument
that changes when it's not supposed to change.

The `volatile` semantics is also important in HLS,
for obvious reasons (see e.g. [the end of this section](#assignments-in-sequential-logic)):
if several accesses are made to the same variable,
optimization often combines them into one,
but if that variable is volatile,
this shouldn't be done.

## Streaming

One way to "regularize" a volatile input is to turn it into a stream.
(This may result in information loss,
but hey, given the fact that actual hardwares take time to do computation,
some data loss is inevitable,
so why not making the sampling rate explicit?)
A volatile output variable, when received by another function as an input variable,
should also be recognized as volatile in the second function.
But if you don't realize that it is volatile,
you may be tempted to do non-justified optimizations.
On the other hand, if an output variable is a stream,
then when it gets passed to another function,
we will never think that several `stream.read()` statements should return the same result.
Another advantage of using streams is that it makes simulation much easier,
as by definition you can't simulate all possible behaviors of a volatile variable
with standard C testbenchs.

Stream programming - programming based on transforming a stream into another - 
is actually a full programming paradigm,
but again no human being really thinks in terms of streaming all the time.
Instead, we use streaming as *tools* that improve certain aspects of traditionally designed algorithms,

Besides the usage as a more semantically clear representation of volatile variables,
streaming can be used for acceleration:
if in a loop over an array, different iterations access independent components of the array,
then the loop can be started *before* all components of the array come:
in this case the array is to be replaced by a stream
and the function is like 
```C
for (i = 0; i < max; i ++) {
    input = stream.read();
    // do something to the input
    output.write(result);
}
```
this can be seen as a more secure version of pipelining:
if no data arrives yet the loop just stalls
(the mechanism may be synthesized as attaching a "data arrived" flag into the stream module,
and if at a clock cycle no data is found to be arriving,
the function just stays in the idle state and the value of the register `result`,
which is garbage, is not injected to `output`).

Just like the case in software engineering, in hardware designing,
we can either write a stream-to-stream program, or a stream-to-array program.
In the second case, we may still have stream-to-stream components (e.g. pipelines) in the design but eventually the stream gets collapsed into an array with an collection operation.

One problem is how can two stream-to-stream functions be used together.
We definitely can't do `func1(&stream1); func2(stream1, &stream2);`
as it requires `func1` to finish first.
In Java we have things like `stream.map(...).reduce(...)`.
We can imagine implementing the same thing in HLS;
note that the function call chain should be compile time decided
or otherwise the code can't be synthesized as it involves dynamic allocation of resources.
A more low-level programming paradigm is probably launching two threads,
which in the context of HLS is just adding two modules that run together.
This is known as [data-driven task level parallelism in Vitis HLS](#parallelism).
Note that from the perspective of software engineering,
the threads are launched by some launching functions,
but in HLS the function calls are synthesized as directly putting the hardware implementations of the threads 
as submodules of the top-level module
(therefore dynamic thread dispatching is not allowed, which is expected because dynamic function calls involves dynamic memory allocation).
In this way, thread launching function calls differ from other function calls in how they get synthesized.
A "wait until thread finish" loop should be synthesized as an additional state in the state variable of the top-level module.
(This however is not supported by Vitis HLS, and is not necessary anyway - see discussion [here](#parallelism))

Finally we discuss some implementation details.
The synthesis of a stream-to-stream function (or, more precisely, a stream-to-stream thread),
if it only contains combinational logic,
can be as simple as the synthesis of the combinational logic:
the output is delayed for a while.
This, of course, is faced by problems like how we can know that the output has already started,
as is already seen [here](#keep-the-circuit-in-mind).
Actual hardware implementations of streaming usually involves FIFO ports between modules.
In this sense, function calls like `stream.read()` are more "real" compared with thread launching:
in the synthesis result of `stream.read()`, we indeed have a memory module (a FIFO) corresponding to `stream`,
and we indeed have a module corresponding to the `read()` method:
what the module does is not too different from how a stream object is implemented in software engineering:
first wait until `stream` is not locked and then lock `stream`,
then check if there is data waiting to be read and if not wait until the data arrives, etc.

## Sequential relation between function calls

The program `func1(a, b, &c); func2(c);` requires `func2` to run after `func1` is finished
because `c` may be modified in `func1`.
It's not likely that all functions are going to finish within one clock cycle
([sometimes we want them to for performance reasons](#note-on-timing), but not always),
If `c` gets synthesized into a physical register - which is quite likely -
we can keep `func2` running and eventually the new value of `c` will "propagate" into `func2`,
so the timing between the two is guanranteed.
The problem however is in the output we have no idea
whether `func2` is throwing out nonsense or sensible data.
It's usually a good idea to have flags specifying
whether a hardware implementation of a function has finished,
or is running,
or is ready for the next batch of input.
This is not a problem in procedural programming
because we have a global program counter,
but in HDL we don't, and the sequential relation has to be done "locally".

If we reflect on how to decompose a sequential logic into two modules,
the solution sketched here - the so-called *ready-valid protocol* - is actually the most natural way:
basically we circle several subsequent states
and use a single state (`DOING_FUNC1`) to represent them in the global state variable,
and then add a local state variable to represent the details in `DOING_FUNC1`.
The "this task has finished" signal activates the next local state variable,
corresponding to the `return` statement.
The "this task is not running and ready to take new input" signal provides additional safety
to make sure it's not possible to have *two* program counters.
Note that here we see that sequential timing in software engineering
corresponds to a best practice in hardware engineering,
as having two program counters active in one function block
results in hardware race conditions in the hardware implementation.

## Object-oriented programming

An object is basically a struct plus a set of methods,
and therefore 
```C++
void some_function() {
    Object obj(a, b, c);
    // ...
    obj.func1();
    obj.func2();
}
```
is synthesized as placing `obj.field1`, `obj.field2`, ... into module `some_function`,
and the two method calls are synthesized into copies of 
`obj.func1` and `obj.func2`, respectively.
To avoid dynamic resource allocation (we cannot instantiate a module at runtime,
which means we cannot do dynamic dispatching),
the class of all variables must be determined at the compiling time:
it is not allowed for a function to return an object
of which we only know an abstract class.

There is another way to convert object-oriented programming to RTL.
A RTL module is literally a set of registers plus a set of event listeners,
so it may have multiple functionalities and therefore qualifies as a hardware implementation of *object* in object-oriented programming.
The method being called can be encoded as a signal passed into the module.
Alternatively, if we allow `static` variables in functions in HLS,
the same thing can also be done in HLS C:
```C
void do_something(int code_of_what_to_be_done, int input1, int input2, int *output) {
    static int status;
    // ...
}
```
What makes a RTL module more flexible is that a RTL module can be instantiated multiple times,
while we cannot create multiple copies of a C function with static variables inside.

The second approach is essentially like writing your own CPU.
Despite being viable, there seems to be no need for HLS tools to support it as a primitive.
If we think about the final synthesis result,
we'll find that the main difference is the interface of the synthesized modules.
A module written in the second approach, after a naive synthesis,
contains a copy and only one copy of the synthesis result of each of its methods,
plus a decoder that decides which method to activate according to the name of the method passed in.
Synthesis of an object as in object-oriented programming in the first approach, on the other hand,
results in possibly several copies of the same function,
but by some optimization some of them can be removed,
often leaving only one copy of each method being invoked.
On the other hand, methods not called are not synthesized at all in the first approach,
while by default they have to be synthesized 
implementations of not used methods,
which are however also subject to optimization.
So as long as the tools are good at optimization,
the final synthesis result of the two approaches will not be different.

## Note on timing

The frequency of the clock is not necessary better if it's higher.
An operation should better fit in one clock cycle,
or otherwise we will need to worry about data contamination,
so if the clock cycle is slightly longer than an operation,
we have a fixed time waste because nothing can be nothing until the second clock cycle finishes.
Reducing the clock frequency
and chaining several operations into one which neatly fits into one clock cycle
in this case is a much better option.

There however is no need for an operation to complete in one clock cycle.
Most of the time it's impossible.

## HLS as best practices for RTL designing

Best practices or design patters in RTL often [naturally emerge from attempts to do HLS](https://www.reddit.com/r/FPGA/comments/1co3ifi/comment/l3ett4k/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button).
Finite state machines correspond to control flows.
Ready/valid protocols correspond to sequential relation keeping mechanisms that make sure `func1(&a); func2(a);` works:
from the software perspective, the ready flag makes sure there is only one program counter when a function is being run,
and the valid flag synthesizes the `return` statement.
Streaming has direct counterparts in software engineering.
Various parallelisms, from instruction level parallelism to multithreading, can be directly transplanted to hardware engineering,
and pipelining can be seen as a reduced case of multithreading,
while sequential execution can be seen as a way to prevent hardware race conditions.
Of course, RTL generated by HLS may contain more boilerplates than handwritten RTL,
which sometimes makes optimization harder,
so in the foreseenable future probably directly writing RTL will be a necessity 
for anyone who needs to make a final product and not just prototypes.

We see that we *can* understand hardware description in the mindset of software engineering.
We however have two caveats.
The first is that the most natural concepts in software engineering,
including structured programming, functions, etc.
are *not* primitives in RTL,
and the elementary concepts in RTL pertain to event-driven programming,
and needs adaption to implement the concepts in ordinary software programming.
The second is that timing and low-level parallelism are significantly more important in hardware designing.
Therefore, if we decide to view hardware engineering in the lens of software engineering,
what we'll want to do is to write programs that run well with
*low* clock frequency but *high* parallelism.

# A rational reconstruction of description levels in digital circuit designing

Here is a rational reconstruction of fundamentals of digital circuit designing, from the perspective of HLS to physical transistors.

1. We have a multithreaded code written in an ordinary language, or probably the behavioral constructs of a HDL. Things like pipelining are understood as multithreading as well.
   This may be known as *behavioral level* modeling.
   Behavioral level designs can sometimes also be synthesized:
   if they are written in C/C++ or sometimes Matlab or Fortran
   this is known as high-level synthesis,
   and if they are written in Verilog or VHDL this is known as behavioral synthesis.
2. Object-oriented features, streaming, etc. are reduced to data shared by functions and function calls. 
   Dynamic memory allocation has a physical upper bound and can be conceived as accessing a large but finite array of variables in practice. 
   All data can be encoded into binary numbers, and thus sequences of bits.
3. In each thread - a function that runs over and over again - the correct timing of successive function calls is implemented by the ready-valid protocol.
4. We analyze the control flow of a single  - and rewrite it into several stages,
   each of which modifies a variable at most once.
   A finite state machine can then be constructed to represent the control flow,
   with loops being represented as loops in the state diagram.
   The operations done at each stage are data flows of that stage.
5. We assume that we're designing clocked circuits. Switch between the stages is then triggered by the clock signals.
   This means the calculation within a stage should finish within in clock cycle,
   or otherwise we need to slow down the clock,
   or break down the stage into multiple stages.
   In actual designs, we need to pay attention to the relation between latency and clock cycle (and timing violations), to maximize the speed and avoid timing violations.
6. Synthesis of all algorithms into hardwares therefore can be broke down to the follows:
   a set of variables (or abstract *registers*), sometimes organized as arrays,
   and a set of event listeners listening to the clock signal.
   In the event listeners we can do assignment, operations, and branching.
   Any event listener is *finite*:
   unbounded loops, as is mentioned above, are to be expressed by a finite state machine.
7. The event listeners can be further broke down into combinational logic (basically, computational graphs that evaluate their outputs whenever the inputs change, defined by continuous assignment `assign xxx = yyy` in Verilog) and sequential logic (`<=` in Verilog). Because each event listener is finite, we can also define blocking assignment (`=` in Verilog). We can generalize a little and allow event listeners to listen to anything and not just the clock signal, and hence combinational logic i.e. continuous assignments can also be expressed in terms of event listeners. Coding using primitives mentioned here is known as RTL.
   Note that in RTL things that are independent to each other run in parallel
   (and all parallelisms reduce to "instruction-level parallelism"),
   so multithreading doesn't need special primitives:
   it's just two modules running independently.

   We note that the distinction between combinational logic and sequential logic makes most sense 
   in clocked circuit designing:
   in theory, both can be described by `always` blocks,
   but only sequential logic involves the clock signal
   (semantically equivalent to the program counter).
8. Most HDLs provide serial or loop structures in the body of the aforementioned event listeners,
   but these structures are confined in their complexities both in abstract semantics and in practical designing (because of problems like delay, etc.).
   Therefore serial execution, `for` loop, etc. in HDLs are *not*
   equivalent to serial execution, `for` loop, etc. in programming languages and HLS:
   the canonical counterpart of the latter is finite state machines that represent the control flows.
   
   The serial execution, `for` loop, etc. in HDLs are supposed to be *small*,
   while serial execution, `for` loops in HLS which are implemented as finite state machines are supposed to be *big*.
   The *small* control flow constructs are *timed*: the time costs of them matter,
   and usually we expect them to finish within one clock cycle.
   The *big* control flow constructs are not timed in this sense
   because as long as the small control flow constructs making up them have no timing violation,
   we don't need to consider timing when designing these big control flow constructs.
   The *small* constructs are RTL and have very clear correspondence to the gate-level circuit design;
   the *big* constructs are behavioral and belong to HLS if they are to be synthesized at all.
9.  Synthesis of RTL boils down to flip-flops and latches (for registers in various stateful `always` blocks), 
    multiplexers and tri-state functions (for branching), decoders (for array accessing), memory blocks, and combinational blocks.
10.  Flip-flops can be made of latches. Latches can be made of combinational blocks with loops. Multiplexers and decoders are nothing but special combinational blocks. Memory blocks are made of flip-flops, decoders, and tri-state functions. So everything in theory is combinational blocks.
    We also note that FPGAs can emulate the behavior of all digital circuits.
    This is kind of like a Turing-completeness test,
    where we demonstrate that at least one digital hardware architecture can emulate all other digital circuits.
    Of course, for this to be a real Turing-completeness test,
    we need infinite FPGA, which we don't have.
    Other "do anything" chips include CPLD.
11. Combinational blocks are made of logic gates (that's why Boolean logic is important), and, when the high-impedance state is needed, controlled switches. This is gate-level description.
    Efficient gate-level design relies heavily on Boolean logic.
12. Logic gates are also made of controlled switches. Controlled switches are made of transistors. This is transistor-level description. How to place transistors on chips is physics- or device-level description.

The levels above are of course never the only way hardware designing can be carried out,
but it's indeed the industrial standard.
Also, above the transistor-level description, almost everything can be done in SystemVerilog, in a quite uniform and coherent way.

Gate-level description, for example, can be seen as a reduced case of RTL,
as basic logic gates and flip-flops are semantically all modules on their own. 
We can "implement" a logic gate with `always_comb` and `if` constructs and comparisons and assignments.
We can "implement" a flip-flop with `always_ff`.

Of course, in actual digital design, the reverse happens:
variables modified in `always_ff` are synthesized into flip-flops and
variables that only appear in `always_comb` are synthesized into logic gates.
What we demonstrate here is that gate-level description is just reduced RTL,
and gates, flip-flops, etc. semantically have no privileged status compared with other modules in RTL.
Therefore in a Verilog file intended for synthesis,
we can *infer* gate-level constructs (like when we use `always_ff` we are *inferring* that flip-flops are to be used),
or we can directly and explicitly specify the gate-level constructs.

We also note that the boundaries between these different levels are all blurred.

First, the boundary between RTL and behavioral description is not so clear.
We definitely will not call statements like `sleep for 100 clock cycles`
or `wait until some condition is met` RTL:
if they are to be synthesized,
quite non-local processes are to be done
(as is discussed above: setting up a state variable, etc.).
But a very large `always` block, which likely won't be finished within one realistic clock cycle,
despite being semantically RTL,
is not supposed to be synthesized directly and you can also argue that's behavioral and not RTL.

Speaking of RTL,
some companies' coding style guidelines suggest getting rid of `always` blocks almost completely,
and using clearly combinational constructs as frequently as possible.
We may still call this RTL when we have assignments;
but turning assignments into wiring is trivial,
and the result is quite close to gate-level description.
So now we see three different ways to write RTL:
- Structural RTL, where we use as much instantiation as possible,
  and therefore `always` blocks are to be replaced by standard stateful modules.
- Dataflow RTL, where we have assignments but they are mostly continuously assignments,
  and `always` blocks are still largely absent.
- Procedural RTL, where `always` blocks appear frequently.

We may say structural RTL is more low-level and procedural RTL is more high-level:
after all, structural RTL is closer to gate-level description,
although as is discussed above,
all the primitives involved in the three types of coding styles
originate naturally from the general concept of RTL,
and if we view `always` blocks as the ultimate primitives,
then structural RTL is the most high-level.

# Cheat sheet 

- Variables plus [event listeners](#event-listener): modules in RTL
- In [HLS](#hls-synthesizes-functions), a function that possibly launches threads is equivalent to a module:
  a function is run as a thread, which links the input and output variables in a certain way,
  and an outside observer can see how the output variables change as the function runs.
  [Concepts in HLS are also good design patterns for manual RTL design](#hls-as-best-practices-for-rtl-designing).
- The three structural programming designing patterns in HLS by default correspond to finite state machines.
- Loops launching threads correspond to `generate for` in RTL.
- Successive, sequential function calls in HLS require handshake signals.
- Multithreading in HLS does not alternate the finite state machine structure of the module corresponding to the top function
- Streaming in HLS correspond to FIFO and the like in RTL
- [Object-oriented programming](#object-oriented-programming) in HLS is synthesized by treating methods as functions

# What is *not* written in RTL

In RTL designs that are to be synthesized,
we expect all operations in one event listener i.e. `always @` finish within one clock cycle.
This is the only notion about timing we have in RTL.
The reality of course is more complicated.
It is, for instance, possible to let operations in one cycle to borrow time from the next cycle.
The RTL methodology isn't well prepared to describe this quantitatively,
and although it is in theory possible to attempt to add notions on timing in RTL,
in real world engineering,
things like time borrowing are usually done *after* synthesis.
