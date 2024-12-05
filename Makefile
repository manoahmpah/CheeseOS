# Définition des fichiers source et objets pour x86_64
x86_64_asm_source_files := $(shell find src/impl/x86_64 -name *.asm)
x86_64_asm_object_files := $(patsubst src/impl/x86_64/%.asm, build/impl/x86_64/%.o, $(x86_64_asm_source_files))

# Règle pour construire les fichiers objets à partir des fichiers ASM
$(x86_64_asm_object_files): build/impl/x86_64/%.o: src/impl/x86_64/%.asm
	mkdir -p $(dir $@)
	nasm -f elf64 $< -o $@

# Cible principale : construire le kernel pour x86_64
.PHONY: build-x86_64
build-x86_64: $(x86_64_asm_object_files)
	mkdir -p dist/x86_64
	x86_64-elf-ld -n -o dist/x86_64/kernel.bin -T targets/x86_64/linker.ld $(x86_64_asm_object_files)
	cp dist/x86_64/kernel.bin targets/x86_64/iso/boot/kernel.bin
	grub-mkrescue -o dist/x86_64/kernel.iso targets/x86_64/iso
