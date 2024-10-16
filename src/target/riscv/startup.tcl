# SPDX-License-Identifier: GPL-2.0-or-later

lappend _telnet_autocomplete_skip "riscv set_enable_virtual"
proc {riscv set_enable_virtual} on_off {
	echo {DEPRECATED! use 'riscv mmu_translation_driver' not 'riscv set_enable_virtual'}
	foreach t [target names] {
		if {[$t cget -type] ne "riscv"} { continue }
		switch -- [$t riscv mmu_translation_driver] {
			off -
			hw {
				switch -- $on_off {
					on  {$t riscv mmu_translation_driver hw}
					off {$t riscv mmu_translation_driver off}
				}
			}
			sw {
				if {$on_off eq "on"} {
					error {Can't enable virtual while translation driver is SW}
				}
			}
		}
	}
	return {}
}

lappend _telnet_autocomplete_skip "riscv set_enable_virt2phys"
proc {riscv set_enable_virt2phys} on_off {
	echo {DEPRECATED! use 'riscv mmu_translation_driver' not 'riscv set_enable_virt2phys'}
	foreach t [target names] {
		if {[$t cget -type] ne "riscv"} { continue }
		switch -- [riscv mmu_translation_driver] {
			off -
			sw {
				switch -- $on_off {
					on  {riscv mmu_translation_driver sw}
					off {riscv mmu_translation_driver off}
				}
			}
			hw {
				if {$on_off eq "on"} {
					error {Can't enable virt2phys while translation driver is HW}
				}
			}
		}
	}
	return {}
}

proc riscv {cmd args} {
	tailcall "riscv $cmd" {*}$args
}
