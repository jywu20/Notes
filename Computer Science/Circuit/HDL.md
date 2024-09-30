Hardware description
==========

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

Sequential execution of a finite list of statements
is always within the regime of combinational logic:
we may have things like `temp = a; a = b, b = temp`,
but we can always routinely eliminates the intermediate variables
and get a mapping from the initial values of `a` and `b`
to the final values of `a` and `b`.

Similarly, the if-else structure, if without loops inside,
can be routinely implemented with combinational logic.

Loops are generally hard to handle in digital circuit designing,
because it strongly depends on things like program counter,
the most straightforward implementation of which needs statements to really be stored somewhere.
If the upper bound of a loop is known,
it can be synthesized by repeating the loop body for several times.
If the upper bound of the loop is not known,
or if the upper bound of the loop depends on the input,
then the loop is not directly synthesizable.
But note that in theory, a program only needs one loop,
and we already have a loop going on forever in sequential logic.
This means we can implement loop conditions of the aforementioned unbounded loops as registers,
update their values in each clock cycle,
and decide what to do in this clock cycle depending on the values of the registers,
effectively deciding whether to keep doing the loop body
or to jump out of the loop.
(Often, though, even when theoretically the loop is unbounded,
in practice we will have a bound above which the problem is not feasible anyway
with the existing resources,
and in hardware design a bounded loop can then be used.)

In theory we can use a fast clock and a slow clock
to implement two embedded loops.
This however is rarely done in reality.

In summary, the best way to turn a procedural code into digital circuits
is to first rewrite it into a *state machine* manually (or with C-to-HDL tools),
and then it should be easy to automatically synthesize.

# Register transfer level (RTL) description

The variant of procedural programming that works on the concept of state machines and is sketched in the last section
in which we have assignments and combinational logic
is known as register transfer level (RTL) description.

The meaning of the name is self-explained;
one thing we need to note however is that the registers mentioned in RTL
are not always physical registers:
it's probably better to call them variables,
as they are abstract entities that, depending on whether their values need to be kept
for the use of the next clock cycle,
are sometimes realized as physical registers and sometimes just some wires.
This distinction reminds us of how stateful programming is modeled in functional programming languages like Haskell;
the implication of this is discussed [here](#functional-programming-in-circuit-designing).

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

Since the concepts of RTL description are close to procedural programming,
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

# Synthesizable building blocks of Verilog

Verilog is a widely used HDL.
It's truly like a software programming language,
in which we don't have direct access to concepts like gates or physical registers
(in Verilog, the term "register" refers to abstract objects that keep the values they are assigned with;
as is said above, registers or variables in Verilog may be synthesized as actual registers,
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
Assignments to the public fields trigger setter methods,
which may also change the internal state of the object.

## Event listener

The `always` block is used to listen to 

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

In Verilog, we have *blocks assignment* and *non-blocking assignment*.
The terms are kind of misleading: *immediate and deferred assignment* seem to be better terms.
In simulations, the former takes effect immediately,
which means that after `a = ...`,
whenever we read `a`, we are reading the new value,
while the latter takes effect after this `always` block,
which means when we read `a` after `a <= ...` we're reading the old value.
This sometimes makes programming easier:
swapping two variables now is as simple as `a <= b; b <= a`.
In synthesizing, block assignment is often used for intermediate variables,
while non-blocking assignment is often used for physical registers,
because non-blocking assignment is closer to how flip-flops work.

It's often possible to separate as much combinational logic as possible from sequential logic.
Suppose we have a `c <= a + b` non-blocking assignment in an `always` block.
It's sequential logic,
but the `a + b` part actually can be replaced by a wire that comes from a continuous assignment outside the `always` block.
So instead we may write a continuous assignment `assign c_w = a + b` outside the `always` block,
and then write `c <= c_w` in the `always` block.
Actually this is how `c <= a + b` is synthesized.

## Summary of semantics of Verilog 

The existence of procedural assignment statements to Verilog variables
make the variables look like variables in procedural programming.
The existence of continuous assignments and `always` block,
however, makes them look like *tensors* in computation graphs in e.g. PyTorch,
to which assignments may change the structure of the computational graph,
or trigger events that are then handled by parallel event listeners.
And actually, function calls are completely replaced by event listener in Verilog.

If regarded as a programming language, Verilog is thoroughly event-driven,
and in each event listener we have procedural programming
(but unbounded loops have to be implemented by event-driven features),
while different event listeners run in parallel.
All variables are like tensors in a deep learning framework because of continuous assignment,
and we have natural constraints forbidding assignment to non-terminal nodes in the computation graph.
Event listeners and variables they share are organized into modules,
and event triggering is as simple as assignment to the input ports of a module.
A module can be instantiated in another module,
in the same way a neural network module is instantiated in a bigger network.

It can be seen that several paradigms that are traditionally considered as high-level - 
multithreading, event listening, computational graph - 
are integrated parts of Verilog,
which however is generally considered a low-level description.
So again, the high-level/low-level distinction is theoretically not always a well-defined concept.
Moreover, Verilog puts these things together in a largely well-integrated way,
unlike languages like C++.

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
which makes the behavior of the circuit unpredictable.

A problem that used to be serious but now has eased is coding style greatly influencing the structure of the synthesized circuit.
If the synthesizer can't optimize the code well,
we can't just write Verilog code however we'd like.
By using the same type of optimization techniques in software engineering,
the situation has been improved, but there are still incidents where the way Verilog is written causes congestion,
meaning that there isn't enough room to put all the wires.


# High-level synthesis

# The target of synthesis

## Stateful objects

By connecting output wires of some components back to the input wires,
we can create multiple stationary states,
and which state the system is in depends on the history of its interaction with the environment.
It's under this general idea that we have *latches*.
A latch has two stationary states, and which state it's in can be told from the signals on the output wires.

This multi-stationary state nature of latches distinguish them from ordinary combinational logic.

Two latches can be used to make a flip-flop.