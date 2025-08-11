# bfDSL

Finally brainfuck dsl for c3! Translate your brainfuck code to c3 right at compile time!

# Examples
```c
import bfdsl;
import std::io;

fn int main() {
    Bf $bf = bfdsl::brainfuck(4096, // Tape size
    `
        +++++++++++[>++++++>+++++++++>++++++++>++++>+++>+<<<<<<-]>+++++
        +.>++.+++++++..+++.>>.>-.<<-.<.+++.------.--------.>>>+.>-.
    `);

    $bf(io::stdin(), io::stdout())!!;

    return 0;
}
```
