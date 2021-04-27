----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/28 22:50:37
-- Design Name: 
-- Module Name: main_tb - Behavioral
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

entity main_tb is
--  Port ( );
end main_tb;

architecture Behavioral of main_tb is
component main
  Port (
        rst : in std_logic;
        clk : in std_logic;  -- 100Mhz
        sw : in std_logic_vector(3 downto 0);
        btn1, btn2, btn3 : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0);
        led_lock, led_emrg : out std_logic
         );
end component;

  function Seg_2_Dec (
    Seg : in std_logic_vector(6 downto 0))
    return integer is
    variable v_TEMP : integer;
  begin
    if (Seg = "1000000") then
      v_TEMP := 0;
    elsif (Seg = "1111001" ) then
      v_TEMP := 1;
    elsif (Seg = "0100100" ) then
      v_TEMP := 2;
    elsif (Seg = "0110000" ) then
      v_TEMP := 3;
    elsif (Seg = "0011001" ) then
      v_TEMP := 4;
    elsif (Seg = "0010010" ) then
      v_TEMP := 5;
    elsif (Seg = "0000010" ) then
      v_TEMP := 6;
    elsif (Seg = "1111000" ) then
      v_TEMP := 7;
    elsif (Seg = "0000000" ) then
      v_TEMP := 8;
    elsif (Seg = "0010000" ) then
      v_TEMP := 9;
    elsif (Seg = "0000110" ) then
      v_TEMP := 99;
    end if;
    return (v_TEMP);
  end;

signal rst : std_logic;
signal clk : std_logic;
signal sw : std_logic_vector(3 downto 0);
signal btn1, btn2, btn3 : std_logic:='0';
signal seg : std_logic_vector(6 downto 0);
signal seg_output : integer;
signal an : std_logic_vector(3 downto 0);
signal led_lock : std_logic;
signal led_emrg : std_logic;

constant clk_period : time := 10ns;

begin

    clock : process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    u_main : main
        port map(rst=>rst, clk=>clk, sw=>sw,
                    btn1=>btn1, btn2=>btn2, btn3=>btn3,
                    seg=>seg, an=>an, led_lock=>led_lock, led_emrg=>led_emrg);
    seg_output <= Seg_2_Dec(seg);
    
    stim : process
    begin
    
    -- reset to lock
                rst <= '1';
        wait for 10ns;
                rst <= '0';
                
    -- open method1
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 10ns;
            sw <= "0001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0011";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0100";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0101";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
        
    -- reset to lock
                rst <= '1';
        wait for 10ns;
                rst <= '0';
                
    -- emergency
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 10ns;
            sw <= "0101";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0100";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0011";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
        
    -- reset to lock
                rst <= '1';
        wait for 10ns;
                rst <= '0';
        
    -- open method2
        wait for 10ns;
                btn3 <= '1';
        wait for 10ns;
                btn3 <= '0';
        wait for 10ns;
            sw <= "0001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0100";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
        
    -- reset to lock
                rst <= '1';
        wait for 10ns;
                rst <= '0';
                
    -- test timed out
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 10ns;
            sw <= "0001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0011";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0100";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0101";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
        
        wait for 5000ns;
        
    -- open method1
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 10ns;
            sw <= "0001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0011";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0100";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
            sw <= "0101";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 10ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 100ns;
        
    -- reset to lock
                rst <= '1';
        wait for 10ns;
                rst <= '0';
        
        wait;
    end process;

end Behavioral;
