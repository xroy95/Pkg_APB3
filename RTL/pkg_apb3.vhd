library ieee;

use ieee.std_logic_1164.all;

package pkg_apb3 is
 
 Constant g_APB3_IF_DATA_WIDTH : natural:=32;
 Constant g_APB3_IF_ADDRESS_WIDTH : natural:=32;
 Constant R : std_logic_vector(1 downto 0):="10";
 Constant RW : std_logic_vector(1 downto 0):="11";
 Constant W : std_logic_vector(1 downto 0):="01";
 Constant Disable : std_logic_vector(1 downto 0):="00";

  type apb3 is record

    -- APB slave interface
    clk                  :   STD_LOGIC;
    sel                  :   STD_LOGIC;
    nRW                :   STD_LOGIC;
    enable               :   STD_LOGIC;
    address                 :   STD_LOGIC_VECTOR(g_APB3_IF_ADDRESS_WIDTH-1
                                    DOWNTO 0);
    wdata                :   STD_LOGIC_VECTOR(g_APB3_IF_DATA_WIDTH-1
                                    DOWNTO 0);
  end record apb3;  

  type apb3_Back is record
    rdata  :std_logic_vector (g_APB3_IF_DATA_WIDTH-1 downto 0);
    ready :  std_logic;
    slverr :  std_logic;
  end record apb3_Back;
 
--Constant C_APB3_ARRAY_SIZE : natural;
type apb3_array is array ( natural range <> ) of apb3;
type apb3_array_Back is array (natural range <>  ) of apb3_Back;
type apb3_adress_array is array (natural range <>  ) of std_logic_vector(15 downto 0);
type apb3_Reg_array is array (natural range <>  ) of std_logic_vector(31 downto 0);
type apb3_Reg_Definition_array is array (natural range <>  ) of std_logic_vector(1 downto 0);

component splitter_apb3_assync is
generic( 
        NUMBER_SLAVE : positive:= 5;
        START_ADRESS :apb3_adress_array(NUMBER_SLAVE downto 0);
        END_ADDRESS :apb3_adress_array(NUMBER_SLAVE downto 0)
);
 port (
        apb3_master : in apb3;
        apb3_master_Back : out apb3_Back;
        apb3_slave_array: out apb3_array ( NUMBER_SLAVE-1 downto 0 );
        apb3_slave_array_Back: in apb3_array_Back ( NUMBER_SLAVE-1 downto 0 )
      ); -- sortie
end component splitter_apb3_assync;
  component apb3_reader is
generic( 
        Number_Reg : positive:= 5;
        REG_DEFINITION :apb3_Reg_Definition_array(Number_Reg-1 downto 0)
);
port (
      reset : in std_logic;
      apb3_master : in apb3;
      apb3_master_Back : out apb3_Back;

      Regs_In : in apb3_Reg_array(Number_Reg-1 downto 0);
      Regs_Out : out apb3_Reg_array(Number_Reg-1 downto 0)

);end component apb3_reader;
end package pkg_apb3;
 
