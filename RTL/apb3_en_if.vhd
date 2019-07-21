 --=============================================================================
-- File Name                           : apb3_en_if.vhd

-- Description                         : This module implements the APB3 slave
--                                       Interface to communicate with APB3
--                                       Master

-- Targeted device                     : Microsemi-SoC
-- Author                              : India Solutions Team
--
-- SVN Revision Information            :
-- SVN $Revision                       :
-- SVN $Date                           :
--
-- COPYRIGHT 2017 BY MICROSEMI
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING
-- RESTRICTIONS FROM MICROSEMI CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN
-- AUTHORIZATION FROM MICROSEMI FOR USE OF THIS FILE, THEN THE FILE SHOULD BE
-- IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
--
--=============================================================================

--=============================================================================
-- Libraries
--=============================================================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
LIBRARY work;
use work.pkg_pwm.all;
use work.pkg_adc.all;

--=============================================================================
-- apb3_en_if entity declaration
--=============================================================================
ENTITY apb3_en_if IS
GENERIC (
-- Generic list
    -- Specifies pwdata_i,prdata_o signal width
    g_APB3_IF_DATA_WIDTH    : INTEGER := 32;

    -- Specifies the width of constants
    g_CONST_WIDTH           : INTEGER := 12;

    -- Specifies the width of ADC module outputs
    g_ADC_OUT_WIDTH         : INTEGER := 12;

    -- Specifies the width of ADC configuration register
    g_ADC_CONFIG_REG_WIDTH  : INTEGER := 6;

    -- Specifies width of all input and output ports
    g_STD_IO_WIDTH          : INTEGER := 32
);
PORT (
-- Port list
    -- APB reset
    preset_i                : IN  STD_LOGIC;
    -- APB clock
    pclk_i                  : IN  STD_LOGIC;

    -- APB slave interface
    psel_i                  : IN  STD_LOGIC;
    pwrite_i                : IN  STD_LOGIC;
    penable_i               : IN  STD_LOGIC;
    paddr_i                 : IN  STD_LOGIC_VECTOR(g_APB3_IF_DATA_WIDTH-1
                                    DOWNTO 0);
    pwdata_i                : IN  STD_LOGIC_VECTOR(g_APB3_IF_DATA_WIDTH-1
                                    DOWNTO 0);
    pready_o                : OUT STD_LOGIC;
    pslverr_o               : OUT STD_LOGIC;
    prdata_o                : OUT STD_LOGIC_VECTOR(g_APB3_IF_DATA_WIDTH-1
                                    DOWNTO 0);

    encoder1_couter                    : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1 DOWNTO 0);
    encoder1_Resolution_last                 : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1 DOWNTO 0);   
    encoder1_Resolution_min                 : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1 DOWNTO 0);   
    encoder1_Resolution_max                    : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1       DOWNTO 0);
    encoder2_couter                    : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1 DOWNTO 0);
    encoder2_Resolution_last                   : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1  DOWNTO 0);
    encoder2_Resolution_min                    : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1  DOWNTO 0);
    encoder2_Resolution_max                    : IN  STD_LOGIC_VECTOR(g_STD_IO_WIDTH-1  DOWNTO 0);
  
    Control_PWM_20 : out pwm_array_20;

  
        adc_channel : in    adc_channel_array --data received




  
);
END apb3_en_if;

--=============================================================================
-- apb3_if architecture body
--=============================================================================

ARCHITECTURE apb3_en_if OF apb3_en_if IS

--=============================================================================
-- Component declarations
--=============================================================================
--NA--

--=============================================================================
-- Synthesis Attributes
--=============================================================================
--NA--

--=============================================================================
-- Signal declarations
--=============================================================================
--PWM 
CONSTANT C_PWM_PERIOD_0         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"000";
CONSTANT C_PWM_PULSE_0         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"004";
CONSTANT C_PWM_PERIOD_1         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"008";
CONSTANT C_PWM_PULSE_1         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"00C";
CONSTANT C_PWM_PERIOD_2         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"010";
CONSTANT C_PWM_PULSE_2          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"014";
CONSTANT C_PWM_PERIOD_3         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"018";
CONSTANT C_PWM_PULSE_3          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"01c";
CONSTANT C_PWM_PERIOD_4         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"020";
CONSTANT C_PWM_PULSE_4          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"024";
CONSTANT C_PWM_PERIOD_5         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"028";
CONSTANT C_PWM_PULSE_5          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"02C";
CONSTANT C_PWM_PERIOD_6         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"030";
CONSTANT C_PWM_PULSE_6         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"034";
CONSTANT C_PWM_PERIOD_7         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"038";
CONSTANT C_PWM_PULSE_7         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"03C";
CONSTANT C_PWM_PERIOD_8         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"040";
CONSTANT C_PWM_PULSE_8          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"044";
CONSTANT C_PWM_PERIOD_9         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"048";
CONSTANT C_PWM_PULSE_9          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"04c";
CONSTANT C_PWM_PERIOD_10         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"050";
CONSTANT C_PWM_PULSE_10          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"054";
CONSTANT C_PWM_PERIOD_11         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"058";
CONSTANT C_PWM_PULSE_11          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"05C";
CONSTANT C_PWM_PERIOD_12         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"060";
CONSTANT C_PWM_PULSE_12         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"064";
CONSTANT C_PWM_PERIOD_13        : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"068";
CONSTANT C_PWM_PULSE_13         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"06C";
CONSTANT C_PWM_PERIOD_14         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"070";
CONSTANT C_PWM_PULSE_14          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"074";
CONSTANT C_PWM_PERIOD_15         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"078";
CONSTANT C_PWM_PULSE_15          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"07c";
CONSTANT C_PWM_PERIOD_16         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"080";
CONSTANT C_PWM_PULSE_16          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"084";
CONSTANT C_PWM_PERIOD_17         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"088";
CONSTANT C_PWM_PULSE_17          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"08C";
CONSTANT C_PWM_PERIOD_18         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"090";
CONSTANT C_PWM_PULSE_18          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"094";
CONSTANT C_PWM_PERIOD_19         : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"098";
CONSTANT C_PWM_PULSE_19          : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"09c";

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
--Encoder


--Encoder Register Addresses
CONSTANT C_ENCODER1_COUNTER        : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"100";
CONSTANT C_ENCODER1_RESOLUTION_LAST        : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"104";
CONSTANT C_ENCODER1_RESOLUTION_MAX       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"108";
CONSTANT C_ENCODER1_RESOLUTION_MIN       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"10C";

CONSTANT C_ENCODER2_COUNTER        : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"110";
CONSTANT C_ENCODER2_RESOLUTION_LAST        : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"114";
CONSTANT C_ENCODER2_RESOLUTION_MAX       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"118";
CONSTANT C_ENCODER2_RESOLUTION_MIN       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"11C";

CONSTANT C_ADC_CHANNEL_0       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"200";
CONSTANT C_ADC_CHANNEL_1       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"204";
CONSTANT C_ADC_CHANNEL_2       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"208";
CONSTANT C_ADC_CHANNEL_3       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"20C";
CONSTANT C_ADC_CHANNEL_4       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"210";
CONSTANT C_ADC_CHANNEL_5       : STD_LOGIC_VECTOR(g_CONST_WIDTH-1
                                           DOWNTO 0) := x"214";




BEGIN


--=============================================================================
-- Top level output port assignments
--=============================================================================
pready_o     <= '1';  -- pready_o Is always ready,there will not be any
                      -- latency from the Fabric modules
pslverr_o    <= '0';  -- Slave error is always '0' as there will not be
                      --any slave error.


--=============================================================================
-- Generate blocks
--=============================================================================
--NA--

--=============================================================================
-- Asynchronous blocks
--=============================================================================
--------------------------------------------------------------------------
-- Name       : READ_DECODE_PROC
-- Description: Process implements the APB read operation
--------------------------------------------------------------------------

READ_DECODE_PROC:
    PROCESS (paddr_i)
    BEGIN
        CASE  paddr_i(11 DOWNTO 0)  IS


--------------------
-- C_IA_REG_ADDR
--------------------
            WHEN C_ENCODER1_COUNTER =>
                prdata_o        <= encoder1_couter;
             WHEN C_ENCODER1_RESOLUTION_LAST =>

                prdata_o        <= encoder1_Resolution_last;
            WHEN C_ENCODER1_RESOLUTION_MIN =>
                prdata_o        <= encoder1_Resolution_min   ;
            WHEN C_ENCODER1_RESOLUTION_MAX =>
                prdata_o        <= encoder1_Resolution_max;

            WHEN C_ENCODER2_COUNTER =>
                prdata_o        <= encoder2_couter;
            WHEN C_ENCODER2_RESOLUTION_LAST =>
                prdata_o        <= encoder2_Resolution_last;
            WHEN C_ENCODER2_RESOLUTION_MIN =>
                prdata_o        <= encoder2_Resolution_min   ;
            WHEN C_ENCODER2_RESOLUTION_MAX =>
                prdata_o        <= encoder2_Resolution_max;
--ADC CHANNEL
            WHEN C_ADC_CHANNEL_0 =>
                prdata_o        <=  adc_channel(0);
            WHEN C_ADC_CHANNEL_1 =>
                prdata_o        <=  adc_channel(1);

            WHEN C_ADC_CHANNEL_2 =>
                prdata_o        <=  adc_channel(2);

            WHEN C_ADC_CHANNEL_3 =>
                prdata_o        <=  adc_channel(3);
            WHEN C_ADC_CHANNEL_4 =>
                prdata_o        <=  adc_channel(4);
            WHEN C_ADC_CHANNEL_5 =>
                prdata_o        <= adc_channel(5);



--------------------
-- EXEMPLE
--------------------
 -- -          WHEN C_IALPHA_REG_ADDR =>
--                prdata_o(g_STD_IO_WIDTH-1 DOWNTO 0)        <= ialpha_i;
---                prdata_o(g_APB3_IF_DATA_WIDTH-1 DOWNTO g_STD_IO_WIDTH)
--                                <= (OTHERS=>ialpha_i(g_STD_IO_WIDTH -1));
--

--------------------
-- OTHERS
--------------------
            WHEN OTHERS =>
            prdata_o <= (OTHERS=>'0');

        END CASE;

    END PROCESS;

--=============================================================================
-- Synchronous blocks
--=============================================================================
--------------------------------------------------------------------------
-- Name       : WRITE_DECODE_PROC
-- Description: Process implements the APB write operation
--------------------------------------------------------------------------
WRITE_DECODE_PROC:
    PROCESS (preset_i, pclk_i)
    BEGIN
        IF(preset_i = '0')THEN
            for I in 0 to 19 loop
                Control_PWM_20(I).period<= (OTHERS => '0');
                Control_PWM_20(I).Duty_cycle<= (OTHERS => '0');
            end loop;


        ELSIF (pclk_i'EVENT AND pclk_i = '1') THEN
            IF ((psel_i = '1') AND (pwrite_i = '1') AND (penable_i = '1')) THEN
                CASE paddr_i(11 DOWNTO 0)  IS
--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_0 =>
                        Control_PWM_20(0).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_0 =>
                        Control_PWM_20(0).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_1 =>
                        Control_PWM_20(1).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_1 =>
                        Control_PWM_20(1).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_2 =>
                        Control_PWM_20(2).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_2 =>
                        Control_PWM_20(2).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_3 =>
                        Control_PWM_20(3).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_3 =>
                        Control_PWM_20(3).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_4 =>
                        Control_PWM_20(4).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_4 =>
                        Control_PWM_20(4).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_5 =>
                        Control_PWM_20(5).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_5 =>
                        Control_PWM_20(5).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_6 =>
                        Control_PWM_20(6).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_6 =>
                        Control_PWM_20(6).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_7 =>
                        Control_PWM_20(7).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_7 =>
                        Control_PWM_20(7).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_8 =>
                        Control_PWM_20(8).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_8 =>
                        Control_PWM_20(8).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_9
--------------------
                    WHEN C_PWM_PERIOD_9 =>
                        Control_PWM_20(9).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_9
--------------------
                    WHEN C_PWM_PULSE_9 =>
                        Control_PWM_20(9).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_0
--------------------
                    WHEN C_PWM_PERIOD_10 =>
                        Control_PWM_20(10).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_10 =>
                        Control_PWM_20(10).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_011
--------------------
                    WHEN C_PWM_PERIOD_11 =>
                        Control_PWM_20(11).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_011
--------------------
                    WHEN C_PWM_PULSE_11 =>
                        Control_PWM_20(11).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_012
--------------------
                    WHEN C_PWM_PERIOD_12 =>
                        Control_PWM_20(12).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_012
--------------------
                    WHEN C_PWM_PULSE_12 =>
                        Control_PWM_20(12).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_013
--------------------
                    WHEN C_PWM_PERIOD_13 =>
                        Control_PWM_20(13).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_013
--------------------
                    WHEN C_PWM_PULSE_13 =>
                        Control_PWM_20(13).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_014
--------------------
                    WHEN C_PWM_PERIOD_14 =>
                        Control_PWM_20(14).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_14 =>
                        Control_PWM_20(14).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_015
--------------------
                    WHEN C_PWM_PERIOD_15 =>
                        Control_PWM_20(15).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_15 =>
                        Control_PWM_20(15).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_016
--------------------
                    WHEN C_PWM_PERIOD_16 =>
                        Control_PWM_20(16).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_16 =>
                        Control_PWM_20(16).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_17
--------------------
                    WHEN C_PWM_PERIOD_17 =>
                        Control_PWM_20(17).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_0
--------------------
                    WHEN C_PWM_PULSE_17 =>
                        Control_PWM_20(17).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_18
--------------------
                    WHEN C_PWM_PERIOD_18 =>
                        Control_PWM_20(18).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_18
--------------------
                    WHEN C_PWM_PULSE_18 =>
                        Control_PWM_20(18).Duty_cycle <= pwdata_i;

--------------------
-- C_PWM_PERIOD_19
--------------------
                    WHEN C_PWM_PERIOD_19 =>
                        Control_PWM_20(19).period <= pwdata_i;
--------------------
-- C_PWM_PULSE_19
--------------------
                    WHEN C_PWM_PULSE_19 =>
                        Control_PWM_20(19).Duty_cycle <= pwdata_i;


--------------------
-- OTHERS
--------------------
                    WHEN OTHERS =>
                        NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

--=============================================================================
-- Component Instantiations
--=============================================================================
--NA--

END ARCHITECTURE apb3_en_if;