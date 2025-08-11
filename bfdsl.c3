module bfdsl;
import std::io;

alias Bf = fn void? (io::InStream, io::OutStream);

macro Bf brainfuck($tape_size, $program_str) @const
{
    return fn void? (io::InStream in, io::OutStream out) 
    {
        char[$tape_size] tape;
        ushort ptr = 0;
        
        return @codegen($program_str, tape, ptr, in, out);
    };
}

macro void? @codegen($program_str, #tape, #ptr, #in, #out) @private
{
    $for var $i = 0; $i < $program_str.len; $i++:
        $switch $program_str[$i]:
        $case '>':
            #ptr++;
        $case '<':
            #ptr--;
        $case '+':
            #tape[#ptr]++;
        $case '-':
            #tape[#ptr]--;
        $case ',':
            char? in_byte = #in.read_byte();
            if (catch excuse = in_byte) {
                if (excuse != io::EOF) {
                    return excuse?;
                }

                in_byte = 0;
            }
            #tape[#ptr] = in_byte!!;
        $case '.':
            #out.write_byte(#tape[#ptr])!;
        $case '[':
            var $loop_end_shift = split_loop($program_str[$i+1..]);
            while (#tape[#ptr] != 0) {
                if (catch excuse = @codegen($program_str[$i+1:$loop_end_shift], #tape, #ptr, #in, #out)) {
                    return excuse?;
                }
            }
            
            $i += $loop_end_shift + 1;
        $case ']':
            $error("Unmatched closing bracket");
        $default:
        $endswitch
    $endfor
}

macro int split_loop($program_str) @const @private
{
    var $depth = 0;
    $for var $i = 0; $i < $program_str.len; $i++:
        $switch $program_str[$i]:
        $case '[':
            $depth++;
        $case ']':
            $if $depth == 0:
                return $i;
            $else
                $depth--;
            $endif
        $default:
        $endswitch
    $endfor

    $if $depth > 0:
        $error("Unmatched open bracket");
    $endif
}
