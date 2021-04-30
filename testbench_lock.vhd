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

entity testbench_lock is
end testbench_lock;

architecture Behavioral of testbench_lock is
component main_lock
  Port (
        clk : in std_logic;  -- 100Mhz
        sw : in std_logic_vector(3 downto 0);
        btn1, btn2, btn3 : in std_logic;
        reset : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0);
        lock_up, safeMode : out std_logic
         );
end component;

signal reset : std_logic;
signal clk : std_logic;
signal sw : std_logic_vector(3 downto 0);
signal btn1, btn2, btn3 : std_logic:='0';
signal seg : std_logic_vector(6 downto 0);
signal an : std_logic_vector(3 downto 0);
signal lock_up : std_logic;
signal safeMode : std_logic;

constant clkPeriod : time := 10ns;

begin

    ck : process
    begin
        clk <= '1';
        wait for clkPeriod/2;
        clk <= '0';
        wait for clkPeriod/2;
    end process;

    u_main_lock : main_lock
        port map(reset=>reset, clk=>clk, sw=>sw,
                    btn1=>btn1, btn2=>btn2, btn3=>btn3,
                    seg=>seg, an=>an, lock_up=>lock_up, safeMode=>safeMode);
    
    stim : process
    begin
    
    -- lock
                reset <= '1';
        wait for 10ns;
                reset <= '0';
                
    -- combination lock
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 10ns;
            sw <= "0000";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0110";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "1001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "1001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 100ns;
        
    -- lock
                reset <= '1';
        wait for 10ns;
                reset <= '0';
                
    -- safeMode
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 30ns;
            sw <= "0111";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0000";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "1001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "1001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0101";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 100ns;
        
    -- lock
                reset <= '1';
        wait for 10ns;
                reset <= '0';
        
    -- improved lock test
        wait for 10ns;
                btn3 <= '1';
        wait for 10ns;
                btn3 <= '0';
        wait for 30ns;
            sw <= "0000";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 100ns;
        
    -- to lock
                reset <= '1';
        wait for 10ns;
                reset <= '0';
                
    -- time_out trigged
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 30ns;
            sw <= "0001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0011";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0100";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0101";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 100ns;
        
        wait for 6us;  -- wait for timed_out
        
    -- open again
        wait for 10ns;
                btn1 <= '1';
        wait for 10ns;
                btn1 <= '0';
        wait for 30ns;
            sw <= "0000";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0110";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "0010";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "1001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 30ns;
            sw <= "1001";
        wait for 5ns;
                btn2 <= '1';
        wait for 50ns;
                btn2 <= '0';
        wait for 1us;
        
    -- close the door
                reset <= '1';
        wait for 10ns;
                reset <= '0';
        
        wait;
    end process;

end Behavioral;
