The overall idea of Verilog HDL has been introduced [here](HDL.md).
The worst coder writes things that simply don't make sense in digital circuits like
unbounded loops in an `always @` block.
A more learned coder writes things that look good
[but are not always synthesizable or synthesize to unexpected designs](#things-that-look-good-but-do-not-synthesize-well).
An even more learned coder writes things that can be synthesized
but are slow in performance, not knowing how to improve it.
Finally, physics matters in correct behaviors of the design,
and some designs are more risky than others.

In resolving problems in the last two classes,
knowing the semantics of Verilog is not enough:
one has to have a rough or even detailed idea of what actually happens in synthesis.
Sometimes, this means having to know how different coding styles
map to different circuit structures,
and Verilog, despite being intended as a way to abstract away hardware details,
now becomes a cryptic way to draw circuit schematics in a text format.

# Things that look good but do not synthesize well

## Overusing blocking assignments

Blocking assignments like 
```Verilog
always @(posedge clk) begin
    a = something_new;
    b = func(a);
end
```
strictly speaking can be synthesized, but `b` gets its value from a combinational logic block
reading from `something_new` and not `a`.
Therefore the correct synthesis violates the ideal that if a register appears on the RHS of an assignment,
it should be linked to the register on the LHS.

The problem is, some tools hold the idea of clear "register appearing in RHS = physical wiring involving the register" dearly,
and simply ignore the order of statements in the `always` block,
so it's like that assignment to `b` is implemented by connecting `b` to `a` anyway,
leading to a simulation-synthesis mismatch.
So in general, blocking assignments should only be used in `always_ff` or `always@(posedge clk)` for intermediate variables
that don't infer flip-flops.

## Unexpected latches

A common mistake is to write something like
```Verilog
always@(*) begin
    if (something) begin
        q = something_else;
    end
end
```
The synthesizer wonders what happens if `something` does not happen:
then `q` has to retain its original value...
and since assignment to `q` is not triggered by the clock signal,
`q` has to be synthesized as a latch.
Hence an unexpected latch.

## Trying to record something at asynchronous reset and fail

In [this blog post](https://danluu.com/why-hardware-development-is-hard/) a rather interesting example is provided.

```Verilog
always @(negedge reset or posedge clk) begin
  if (reset == 0) begin
    d_out <= 16'h0000;
    laststoredvalue <= d_out;
  end else begin
    d_out <= d_out + 1'b1;
  end
end
```

The intention of the listing is quite clear:
whenever the `reset` signal is on,
clean up the counter `d_out`,
and store its old value to a logging register.

`d_out` indeed gets synthesized as a standard array of flip-flops:
as all assignment statements in the `always` block are non-blocking,
we can break the `always` block into multiple event listeners.
The one pertaining to `d_out` is 
```Verilog
always @(negedge reset or posedge clk) begin
  if (reset == 0) begin
    d_out <= 16'h0000;
  end else begin
    d_out <= d_out + 1'b1;
  end
end
```
which is the standard description of a accumulator.

The one pertaining to `laststoredvalue` however is 
```Verilog
always @(negedge reset or posedge clk) begin
  if (reset == 0) begin
    laststoredvalue <= d_out;
  end
end
```
Now here is a problem. How should `laststoredvalue` be synthesized?
It appears in a clocked `always` block,
so it has to be flip-flop... right?
But then it's never updated in the clocked way:
it gets updated only when `reset` goes to zero,
which is not necessarily synchronous to the clock signal.

Now, if the synthesizer respects the semantics of the listing,
`laststoredvalue` should be a latch:
its value is updated only when `!reset` is true.
But this won't happen if the synthesizer treats any variable appearing within 
`always` blocks that are triggered by the clock signal
as flip-flop, which, for most cases, is indeed the right thing to do.

# Things that synthesize but are of poor performance



# Problems related to physics

## Metastable states