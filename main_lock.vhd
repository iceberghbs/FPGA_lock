library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_lock is
  Port (
        clk : in std_logic;  -- 100Mhz
        sw : in std_logic_vector(3 downto 0);
        btn1, btn2, btn3 : in std_logic;
        reset : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0);
        lock_up, safeMode : out std_logic
         );
end main_lock;

architecture Behavioral of main_lock is

component fsmCore
  Port (
        clk : in std_logic;  -- 100Mhz
        btn1, btn2, btn3 : in std_logic;
        sw : in std_logic_vector(3 downto 0);
        reset : in std_logic;
        segdata3, segdata2 : out std_logic_vector(3 downto 0);
        segdata1, segdata0 : out std_logic_vector(3 downto 0);
        lock_up, safeMode : out std_logic
         );
end component;

component freDiv
    generic(n:integer:=2); 
    Port (  clock_in : in std_logic;
            clock_out : out std_logic
            );
end component;

component segs_ctrl
  Port (
        data3 : in std_logic_vector(3 downto 0);
        data2 : in std_logic_vector(3 downto 0);
        data1 : in std_logic_vector(3 downto 0);
        data0  : in std_logic_vector(3 downto 0);
        clk : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
        );
end component;

signal data3, data2 : std_logic_vector(3 downto 0);
signal data1, data0 : std_logic_vector(3 downto 0);
signal clk10Mhz : std_logic;

begin
        
    inst_freDiv : entity work.freDiv(rtl)
        generic map(n=>10)
        port map(clock_in=>clk, clock_out=>clk10Mhz);
        
    inst_segs_ctrl : entity work.segs_ctrl(Behavioral)
        port map(data3=>data3, data2=>data2, data1=>data1, data0=>data0, 
                   clk=>clk10Mhz, seg=>seg, an=>an);
                   
    inst_fsmCore : entity work.fsmCore(Behavioral)
        port map(clk=>clk, btn3=>btn3, btn2=>btn2, btn1=>btn1,
                    sw=>sw, reset=>reset, segdata3=>data3, 
                    segdata2=>data2, segdata1=>data1, 
                    segdata0=>data0, lock_up=>lock_up,
                    safeMode=>safeMode);

end Behavioral;
