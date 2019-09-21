--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: apb3_reader.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::SmartFusion2> <Die::M2S025> <Package::256 VF>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;
library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.pkg_apb3.all;
entity apb3_reader is
generic( 
        Number_Reg : positive:= 4;
        REG_DEFINITION :apb3_Reg_Definition_array(Number_Reg-1 downto 0):=(R,R,R,W)
);
port (
      reset : in std_logic;
      apb3_master : in apb3;
      apb3_master_Back : out apb3_Back;

      Regs_In : in apb3_Reg_array(Number_Reg-1 downto 0);
      Regs_Out : out apb3_Reg_array(Number_Reg-1 downto 0)

);
end apb3_reader;
architecture architecture_apb3_reader of apb3_reader is
   -- signal, component etc. declarations
	signal Internal_Reg : apb3_Reg_array(Number_Reg-1 downto 0):=(others=>(others=>'1'));
	signal Internal_Reg_In : apb3_Reg_array(Number_Reg-1 downto 0):=(others=>(others=>'1'));
 signal adress ,wdata: std_logic_vector(31 downto 0);
begin
--=============================================================================
-- Top level output port assignments
--=============================================================================
apb3_master_Back.ready     <= '1';  -- pready_o Is always ready,there will not be any
                      -- latency from the Fabric modules
apb3_master_Back.slverr    <= '0';  -- Slave error is always '0' as there will not be
                      --any slave error.

         
   -- architecture body

WRITE_DECODE_PROC:
    PROCESS (reset, apb3_master.clk)
    BEGIN
        IF(reset = '0')THEN
            for I in 0 to Number_Reg-1 loop
                Internal_Reg(I)<= (OTHERS => '1');
wdata<=(OTHERS => '0');
            end loop;


        ELSIF (apb3_master.clk'EVENT AND apb3_master.clk = '1') THEN
    adress <=apb3_master.address;
            IF ((apb3_master.sel = '1') AND (apb3_master.nRW = '1') AND (apb3_master.enable = '1')) THEN
                    Internal_Reg(to_integer(unsigned(apb3_master.address(g_APB3_IF_ADDRESS_WIDTH-1 downto 2))))<=apb3_master.wdata;
    wdata<=apb3_master.wdata;

            END IF;
        END IF;
    END PROCESS;
apb3_master_Back.rdata        <= Internal_Reg_IN(to_integer(unsigned(apb3_master.address(g_APB3_IF_ADDRESS_WIDTH-1 downto 2))) );

G: for I in 0 to Number_Reg-1 generate
    if_gen : if REG_DEFINITION(i)=R generate
        Internal_Reg_IN(I)<=Regs_In(i);
    end generate if_gen;    
    if_gen0 : if REG_DEFINITION(i)=W generate
        Regs_Out(i)<= Internal_Reg(I);
        Internal_Reg_IN(I)<= Internal_Reg(I);
    end generate if_gen0;
    if_genRW : if REG_DEFINITION(i)=RW generate
        Regs_Out(i)<= Internal_Reg(I);
Internal_Reg_IN(I)<= Internal_Reg(I);

    end generate if_genRW;    
    if_genD : if REG_DEFINITION(i)=Disable generate
        Regs_Out(i)<= (others=>'0');
    end generate if_genD;
end generate G;

end architecture_apb3_reader;
