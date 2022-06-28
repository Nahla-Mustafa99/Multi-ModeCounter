# Multi-ModeCounter

- a multi-mode counter, that can count up, down, by ones and by twos. 
- There is a two-bit control bus input indicating which one of the four modes is active.
- There is initial value input and a control signal called INIT. when INIT is
logic 1, parallelly load that initial value into the multi-mode counter.
- Whenever the count is equal to all zeros, a signal called LOSER will go high, and when the count is all ones, a signal called WINNER will go high, in either case, the set signal should remain high for only one cycle.
- With a pair of plain binary counters, count the number of times WINNER and LOSER goes high, and when one of them reaches 15, set an output called GAMEOVER high.
- If the game is over because LOSER got to 15 first, set a two-bit output called WHO to
2’b01, but if the game is over because WINNER got to 15 first, set WHO to 2’b10.
- WHO should start at 2’b00 and return to it after each game over.
## Objectives
- Designing a module that implements the mechanism described above.
- A testbench (implemented as a program) that generates the required inputs to test the different scenarios.
- make sure the design is correct by investigating the generated wave diagrams.
- An interface with the appropriate set of modports, and clocking blocks.
- Design a top module.
- Assertions to ensure that some illegal scenarios can’t be generated.
