- [Installation](#installation)
- [Patch Details](#patch-details)
  - [Bump Version](#bump-version)
  - [RP05.PEGP, AE_NOT_FOUND](#rp05pegp-ae_not_found)

# MSI Modern 15 A10M ACPI DSDT Patch

This patch fixes some ACPI bugs reported by the Linux kernel.

- **Use it at your own risk**
- SKU: `MSI Modern 15 A10M-408XRU`
- BIOS Version: `E1551IMS.10F`
- Firmware Version: `1551EMS1.107`

## Installation

1. Make sure that you are using exactly the same BIOS and firmware versions as listed above.

    If not, you can fix the code yourself using the information from the [Patch Details](#patch-details) section.

2. Extract the binary ACPI tables and disassemble it for later diff examination with the patched code.

    ```
    # pacman -S acpica
    # cat /sys/firmware/acpi/tables/DSDT > original_dsdt
    $ iasl -d original_dsdt
    ```

3. Download the patched source code, examine it by comparing it with the original version and compile it.

    ```
    $ wget https://github.com/navna/msi-modern-15-a10m-acpi/raw/main/dsdt.dsl
    $ git diff original_dsdt.dsl dsdt.dsl
    $ iasl -tc dsdt.dsl
    ```

3. [Install](https://wiki.archlinux.org/title/DSDT#Using_modified_code) it.

    - Create the CPIO archive and copy it to the boot directory:

        ```
        $ mkdir -p kernel/firmware/acpi
        $ cp dsdt.aml kernel/firmware/acpi
        $ find kernel | cpio -H newc --create > acpi_override.img
        # cp acpi_override.img /boot
        ```

    - Configure the bootloader (systemd-boot example):

        ```
        title   Arch Linux
        linux   /vmlinuz-linux
        initrd  /acpi_override.img
        initrd  /initramfs-linux.img
        options  ...
        ```

## Patch details

### Bump Version

#### Original Source Code

``` dsl
DefinitionBlock ("", "DSDT", 2, "MSI_NB", "MEGABOOK", 0x01072009)
```

#### Remarks

Increase the OEM version. Otherwise, [the kernel will not apply](https://wiki.archlinux.org/title/DSDT#Recompiling_it_yourself) the modified ACPI table.

#### Patched Source Code

``` dsl
DefinitionBlock ("", "DSDT", 2, "MSI_NB", "MEGABOOK", 0x0107200A)
```

### RP05.PEGP, AE_NOT_FOUND

#### Linux Kernel Report

```
ACPI BIOS Error (bug): Could not resolve symbol [^^^RP05.PEGP], AE_NOT_FOUND
ACPI Error: Aborting method \_SB.PCI0.LPCB.EC._QD1 due to previous error (AE_NOT_FOUND)
```

#### Original Source Code

``` dsl
Method (_QD1, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
{
    Notify (^^^RP05.PEGP, 0xD1) // Hardware-Specific
    SCIC = 0xD1
    DBG8 = 0xD1
}

...

Method (_QD5, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
{
    Notify (^^^RP05.PEGP, 0xD5) // Hardware-Specific
    SCIC = 0xD5
    DBG8 = 0xD5
}
```

#### Remarks

It [seems](https://www.insanelymac.com/forum/topic/329311-help-me-to-disabling-nvidia-card/) that RP05.PEGP is a discrete GPU, which does not exist in the A10M (unlike the similar models A10RAS and A10RBS). Perhaps the line with `Notify` can simply be deleted. But to be on the safe side, we just added an existence check.

#### Patched Source Code

``` dsl
Method (_QD1, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
{
    If (CondRefOf (^^^RP05.PEGP))
    {
        Notify (^^^RP05.PEGP, 0xD1) // Hardware-Specific
    }

    SCIC = 0xD1
    DBG8 = 0xD1
}

...

Method (_QD5, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
{
    If (CondRefOf (^^^RP05.PEGP))
    {
        Notify (^^^RP05.PEGP, 0xD5) // Hardware-Specific
    }

    SCIC = 0xD5
    DBG8 = 0xD5
}
```
