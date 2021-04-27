----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/26 00:15:14
-- Design Name: 
-- Module Name: main - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
  Port (
        rst : in std_logic;
        clk : in std_logic;  -- 100Mhz
        sw : in std_logic_vector(3 downto 0);
        btn1, btn2, btn3 : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0);
        led_lock, led_emrg : out std_logic
         );
end main;

architecture Behavioral of main is

component frq_div
    generic(n:integer);  -- frq_div_coefficient
    Port (  clkin : in STD_LOGIC;
            clkout : out std_logic
            );
end component;

component four_digits
  Port (
        d3 : in std_logic_vector(3 downto 0);
        d2 : in std_logic_vector(3 downto 0);
        d1 : in std_logic_vector(3 downto 0);
        d0 : in std_logic_vector(3 downto 0);
        ck : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
--        dp : out std_logic
        );
end component;

component fsm_lock
  Port (
        rst : in std_logic;
        clk : std_logic;
        clk_1hz : in std_logic;
        sw : in std_logic_vector(3 downto 0);
        btn1, btn2, btn3 : in std_logic;
        d1, d0 : out std_logic_vector(3 downto 0);
        led_lock, led_emrg : out std_logic
         );
end component;

signal clk_1hz : std_logic;
signal clk_10Mhz : std_logic;
signal d3, d2 : std_logic_vector(3 downto 0);
signal d1, d0 : std_logic_vector(3 downto 0);

begin
    u1_frq_div : frq_div
        generic map(n=>10)  -- 100000000
        port map(clkin=>clk, clkout=>clk_1hz);
        
    u2_frq_div : frq_div
        generic map(n=>10)
        port map(clkin=>clk, clkout=>clk_10Mhz);
        
    d3 <= "0000";
    d2 <= "0000";
    u_four_digits : four_digits
        port map(d3=>d3, d2=>d2, d1=>d1, d0=>d0, 
                   ck=>clk_10Mhz, seg=>seg, an=>an);

    u_fsm_lock : fsm_lock
        port map(rst=>rst, clk=>clk, clk_1hz=>clk_1hz,
                    sw=>sw, btn1=>btn1, btn2=>btn2, btn3=>btn3,
                    d1=>d1, d0=>d0, led_lock=>led_lock, led_emrg=>led_emrg);

end Behavioral;
