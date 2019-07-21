
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library work;
use work.pkg_apb3.all;
entity splitter_apb3_assync is
generic( 
        NUMBER_SLAVE : positive:= 4;
        START_ADDRESS :apb3_adress_array(NUMBER_SLAVE-1 downto 0):=(x"0000",x"0100",x"0200",x"0300");
        END_ADDRESS :apb3_adress_array(NUMBER_SLAVE-1 downto 0):= (x"00A0",x"01FF",x"02FF",x"03FF")
);
 port (
      apb3_master : in apb3;
      apb3_master_Back : out apb3_Back;
      apb3_slave_array: out apb3_array ( NUMBER_SLAVE-1 downto 0 );
      apb3_slave_array_Back: in apb3_array_Back ( NUMBER_SLAVE-1 downto 0 )

     ); -- sortie
end  splitter_apb3_assync;
architecture architecture_splitter_apb3_assync of splitter_apb3_assync is
   -- signal, component etc. declarations

begin
GEN : FOR i IN 0 to NUMBER_SLAVE-1 generate
        apb3_slave_array(i).sel<=apb3_master.sel when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i) else '0';
        apb3_slave_array(i).nRW<=apb3_master.nRW when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i)else '1';
        apb3_slave_array(i).enable<=apb3_master.enable when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i)else '0';
        apb3_slave_array(i).wdata<=apb3_master.wdata when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i);
        apb3_slave_array(i).address<=apb3_master.address-START_ADDRESS(i) when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i);
        apb3_slave_array(i).clk<=apb3_master.clk;

        
end generate GEN;
GEN1 : FOR i IN 0 to NUMBER_SLAVE-1 generate
        apb3_master_Back.rdata<=apb3_slave_array_Back(i).rdata when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i) else (others=>'Z');
        apb3_master_Back.ready<=apb3_slave_array_Back(i).ready when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i) else 'Z';
        apb3_master_Back.slverr<=apb3_slave_array_Back(i).slverr when apb3_master.address <END_ADDRESS(i) and apb3_master.address>START_ADDRESS(i) else 'Z';
end generate GEN1;


end architecture_splitter_apb3_assync;