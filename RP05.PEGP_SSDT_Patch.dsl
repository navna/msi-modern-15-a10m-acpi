/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200925 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of iASLSiZ9tk.aml, Thu Jul 21 11:51:01 2022
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000167 (359)
 *     Revision         0x02
 *     Checksum         0xA4
 *     OEM ID           "hack"
 *     OEM Table ID     "XQD1"
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "INTL"
 *     Compiler Version 0x20200925 (538970405)
 */
DefinitionBlock ("", "SSDT", 2, "hack", "QD1_QD5 Rename", 0x00000000)
{
    External (_SB_.PCI0.LPCB.EC__, DeviceObj)
    External (_SB_.PCI0.LPCB.EC__.XQD1, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.LPCB.EC__.XQD5, MethodObj)    // 0 Arguments
    External (_SB_.PCI0.RP05.PEGP, DeviceObj)
    External (DBG8, IntObj)
    External (SCIC, IntObj)

    Scope (_SB.PCI0.LPCB.EC)
    {
        Method (_QD1, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                If (CondRefOf (^^^RP05.PEGP))
                {
                    Notify (^^^RP05.PEGP, 0xD1) // Hardware-Specific
                }

                SCIC = 0xD1
                DBG8 = 0xD1
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQD1 ()
            }
        }

        Method (_QD5, 0, NotSerialized)  // _Qxx: EC Query, xx=0x00-0xFF
        {
            If (_OSI ("Darwin"))
            {
                If (CondRefOf (^^^RP05.PEGP))
                {
                    Notify (^^^RP05.PEGP, 0xD5) // Hardware-Specific
                }

                SCIC = 0xD5
                DBG8 = 0xD5
            }
            Else
            {
                \_SB.PCI0.LPCB.EC.XQD5 ()
            }
        }
    }
}

