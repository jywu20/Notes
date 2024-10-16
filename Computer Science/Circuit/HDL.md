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
The ideas developed in this section are related to both [RTL](#register-transfer-level-rtl-description)
and [high-level synthesis (HLS)](#high-level-synthesis-hls).

Sequential execution of a finite list of statements
is always within the regime of combinational logic,
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
But note that in theory, a program only needs one loop,
and we already have a loop going on forever in sequential logic,
which is usually done by a clock
but in theory can also be handled by various asynchronous mechanisms.
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
is to first rewrite unbounded loops are rewritten into a single large loop,
and hence the loop body describes a *state machine*,
and then it should be easy to automatically synthesize.
This can be done manually,
and the description of the state machine is actually
what is known as [RTL](#register-transfer-level-rtl-description).
After discussing the general ideas of RTL,
we will dive into Verilog, a quite popular HDL,
whose semantics we find is actually quite close to 
[a computational graph with a lot of event listeners](#summary-of-semantics-of-verilog).
We can also use [C-to-RTL tools](#high-level-synthesis-hls).

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
however, makes them look like *tensors* in computational graphs in e.g. PyTorch,
to which assignments may change the structure of the computational graph,
or trigger events that are then handled by parallel event listeners.
And actually, function calls are completely replaced by event listener in Verilog.

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

# The target of synthesis

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

## Stateful objects in digital circuits

By connecting output wires of some components back to the input wires,
we can create multiple stationary states,
and which state the system is in depends on the history of its interaction with the environment.
It's under this general idea that we have *latches*.
A latch has two stationary states, and which state it's in can be told from the signals on the output wires.

This multi-stationary state nature of latches distinguish them from ordinary combinational logic.

Two latches can be used to make a flip-flop.

# High-level synthesis (HLS)

Although as is mentioned above, the abstract semantics of a RTL HDL somehow
is close to what are sometimes known as high-level concepts,
an unfortunate fact is that we human programmers never think in this kind of formalism
when designing algorithms.
It's still desirable to design hardwares using standard procedural programming.
This is known as high-level synthesis (HLS),
where the term "high-level" is more about being close to how we humans understand problems.

There are several aspects that make HLS hard.
The problem is ideally the semantics of the programming language
should be easily transferable to RTL,
but the most popular programming languages are not designed in this way.

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

The compromise is to pick up a language - usually C or C++ in practice - 
and synthesize only a subset of it,
controlled by pragmas.
Here we discuss some aspects of C-to-RTL conversion.

## What typically are not supported in HLS

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

## Note on timing

The frequency of the clock is not necessary better if it's higher.
An operation should better fit in one clock cycle,
or otherwise we will need to worry about data contamination,
so if the clock cycle is slightly longer than an operation,
we have a fixed time waste.
Reducing the clock frequency
and chaining several operations into one which neatly fits into one clock cycle
in this case is a much better option.

## Pointers