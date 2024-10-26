Hardware description
==========

This note is carried out in a round-by-round way,
starting from *high level synthesis*,
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
(Note that very often when we talk about finite state machine in RTL,
we're talking about a finite state machine that controls the stage of computation,
or in other words, the control flow:
see [here](#digital-circuits-compared-with-structured-programming)).

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

In newer versions of Verilog, we have three additional `always` blocks:
`always_comb`, which is basically `always @(*)` that requires its content to be pure combinational logic;
`always_latch`, which makes clear that registers in it are to be synthesized as latches;
finally `always_ff`, which makes clear that registers in it are to be synthesized as flip-flops.

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
and in each event listener we have procedural programming
(but unbounded loops have to be implemented by event-driven features),
while different event listeners run in parallel.
All variables are like tensors in a deep learning framework because of continuous assignment,
and we have natural constraints forbidding assignment to non-terminal nodes in the computational graph.
Event listeners and variables they share are organized into modules,
and event triggering is as simple as assignment to the input ports of a module.
A module can be instantiated in another module,
in the same way a neural network module is instantiated in a bigger network.

It can be seen that several paradigms that are traditionally considered as high-level - 
event listening, computational graph,
and possible parallelism originating from the structure of the computational graph - 
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

# The target of synthesis

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
There are many ways to do this,
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
We may also want to specify whether the output of the LUT should be stored in a register.
This can be done by linking the output wire of the LUT memory to two branches,
one being a simple wire and the other being a flip-flop,
and the two wires are then linked to a multiplexer,
which is controlled by the output of another flip-flop.
The second flip-flop receives a signal that controls whether the output of the whole thing
comes from the simple wire or the flip-flop.

So now, by connecting the LUT memory and the flip-flop controlling the multiplexer,
we can program the LUT into an arbitrary logic gate,
with or without its output buffered in a flip-flop.

Now we want to know if this kind of architecture can indeed emulate all digital circuits.
This is theoretically trivially true because by programming the routing tracks and switch boxes we can easily connect arbitrary two LUTs.
The main problem will be whether there are enough tracks for routing,
and there is in general no guarantee that a large circuit can be emulated before we run out of tracks.
The FPGA architecture, after all, is designed to maximize the resources that can be placed on the chip,
not to make hardware development for it easy.

Actual FPGAs contain further components,
including block RAMs (BRAMs), DSP blocks, and also IO blocks connected to the tracks.
They can all be invoked by the programmable gate array.

# High-level synthesis (HLS)

Although as is mentioned above, the abstract semantics of RTL 
is basically computational graph plus event listeners,
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

HLS targets functions, which are natural counterparts of modules in RTL, with some caveats.
The way the synthesis result of a function is supposed to be used is called the interface of the module,
and here we discuss some issues in interface synthesis.

The first caveat is that
ordinary functions are supposed to be called in sequence,
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
as well as [parallelism](#parallelism) that is both important in CPU programs and in HDL.

Besides all signals for control and data flows and their intended usages (i.e. protocols),
we also have the good old clock and reset signals on the interface.

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
This kind of design reduces the idle time of the operations.

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
It's more like *instruction-level parallelism* and less like multithreading:
if two code blocks are independent to each other,
then they can be synthesized separately.
Multithreading-like parallelism does exist in loop unrolling:
when iterations of a loop are big but largely independent,
after they get unrolled, they're synthesized into identical copies of circuits that run like threads.

It's often the case that two independent loops are *not* implemented in parallel,
possibly because if they are to be implemented in parallel,
the resulting state machine will contain too many states.
Vitis HLS provides a "data flow" pragma that results in multitasking
that enables multitasking.
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
because it is not allowed to end a thread:
all we can do is 
```C
while(1) {
    // See if something new happens
    // ...
}
```
If we want threads to formally end,
we can only use the `dataflow` pragma.
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
but `output_stream_merged.read()` finishes only when there is data left in `output_stream_merged`,
and therefore before the threads finish their jobs (after which they are still running but have nothing left to do) the loop will not finish.
And once the loop finish we get back to sequential execution again.
From the perspective of hardware design,
the function calls `output_stream_merged.read()` are probably synthesized into a module that doesn't set its "finished" signal to true
before `number_of_expected_output` outputs are received
(see [here](#sequential-relation-between-function-calls)).
Note that the first `for` loop, in its essence,
is a more advanced version of pipelining:
we can write a pipelined algorithm in HLS 
by launching a thread for each step in the algorithm,
and the synthesis result is just a pipelined circuit.
The main difference between pipelining and the first `for` loop is essentially
that in pipelining we know that each step finishes within one clock cycle,
so the streams can be replaced by simple registers.
The second `for` loop is similar to the "result collector" after a pipeline.

We can also combine the two types of parallelism together.
It's trivially possible to use data-driven task-level parallelism in a control-drive task-level parallelism thread,
and we can also employ the scheme sketched in the last code block
to embed a complicated streaming algorithm into control-drive task-level parallelism,
as is shown [here](https://docs.amd.com/r/en-US/ug1399-vitis-hls/Mixing-Data-Driven-and-Control-Driven-Models).


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
we will never think that several `stream.read()` statements are to be combined into one.
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
If `c` gets synthesized into a register - which is quite likely -
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
the solution sketched here is actually the most natural way:
basically we circle several subsequent states
and use a single state (`DOING_FUNC1`) to represent them in the global state variable,
and then add a local state variable to represent the details in `DOING_FUNC1`.
The "this task has finished" signal activates the next local state variable,
corresponding to the `return` statement.
The "this task is not running and ready to take new input" signal provides additional safety
to make sure it's not possible to have *two* program counters.

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
Various parallelisms can be directly transplanted to hardware engineering,
and pipelining can be seen as a reduced case of multithreading.
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
What we're doing actually is to see how to ensure good performance
given *low* clock frequency but *high* parallelism.