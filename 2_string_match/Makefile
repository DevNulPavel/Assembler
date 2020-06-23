# https://stackoverrun.com/ru/q/5484271
# https://coderoad.ru/5649/x86-Assembly-%D0%BD%D0%B0-Mac
# http://utyatnishna.ru/info/10487/cant-link-object-file-using-ld-mac-os-x

default: | clean string_match.o
	ld -m elf_i386 string_match.o -o string_match_bin && \
	echo "\n\nRun program:" && \
	./string_match_bin "text1" "text?"

string_match.o:
	nasm -f elf32 -o string_match.o string_match.asm

clean:
	rm -f *.o ./string_match_bin
