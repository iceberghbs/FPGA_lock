----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/02/10 23:30:19
-- Design Name: 
-- Module Name: four_digits - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity segs_ctrl is
  Port (
        data3 : in std_logic_vector(3 downto 0);
        data2 : in std_logic_vector(3 downto 0);
        data1 : in std_logic_vector(3 downto 0);
        data0 : in std_logic_vector(3 downto 0);
        clk : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
        );
end segs_ctrl;

architecture Behavioral of segs_ctrl is
signal seg3 : std_logic_vector(6 downto 0);
signal seg2 : std_logic_vector(6 downto 0);
signal seg1 : std_logic_vector(6 downto 0);
signal seg0 : std_logic_vector(6 downto 0);
begin

    sevenseg_3 : entity work.sevenseg(dataflow)
        port map (number => data3, segments => seg3);

    sevenseg_2 : entity work.sevenseg(dataflow)
        port map (number => data2, segments => seg2);

    sevenseg_1 : entity work.sevenseg(dataflow)
        port map (number => data1, segments => seg1);

    sevenseg_0 : entity work.sevenseg(dataflow)
        port map (number => data0, segments => seg0);
    
    process(clk)
        variable cnt : std_logic_vector(1 downto 0):="00";
    begin
    
        if (clk'event and clk='1') then
            cnt := cnt + 1;
        end if;

        case cnt is 
            when "00"=> an<="0111";
            when "01"=> an<="1011";
            when "10"=> an<="1101";
            when "11"=> an<="1110";
            when others=> null;
        end case;

        case cnt is
            when "00"=> seg<=seg3;
            when "01"=> seg<=seg2;
            when "10"=> seg<=seg1;
            when "11"=> seg<=seg0;
            when others=> null;
        end case;

        end process;
    
end Behavioral;
