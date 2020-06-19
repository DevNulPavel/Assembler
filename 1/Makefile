# https://stackoverrun.com/ru/q/5484271
# https://coderoad.ru/5649/x86-Assembly-%D0%BD%D0%B0-Mac
# http://utyatnishna.ru/info/10487/cant-link-object-file-using-ld-mac-os-x

default: | clean hello_5_times.o
	# -m elf_i386 	
	# -arch elf_i386
	# Entry point: -e main
	# ld -no_pie -macosx_version_min 10.15 -arch i386 hello_5_times.o -o hello_5_times_bin
	#ld -no_pie -e main -lSystem -macosx_version_min 10.15 -arch x86_64 hello_5_times.o -o hello_5_times_bin
	ld hello_5_times.o -o hello_5_times_bin

hello_5_times.o:
	# All architectures: nasm -hf
	# nasm -f macho32 hello_5_times.asm -o hello_5_times.o
	# nasm -f macho64 -o hello_5_times.o hello_5_times.asm
	# -f elf32
	nasm -f elf -o hello_5_times.o hello_5_times.asm

clean:
	rm -f *.o ./hello_5_times_bin
