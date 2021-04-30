library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fsmCore is
  Port (
        clk : in std_logic;  -- 100Mhz
        btn1, btn2, btn3 : in std_logic;
        sw : in std_logic_vector(3 downto 0);
        reset : in std_logic;
        segdata3, segdata2 : out std_logic_vector(3 downto 0);
        segdata1, segdata0 : out std_logic_vector(3 downto 0);
        lock_up, safeMode : out std_logic
         );
end fsmCore;

architecture Behavioral of fsmCore is

type state_type is 
    (locked, unlocked, safe, typein4, typein3, typein2, typein1, typein0,
        comparing, wait1m, wait3m, wait10m);
signal state, next_state : state_type;

signal readin_digits : unsigned(19 downto 0);
signal readin_digits2 : unsigned(7 downto 0);
signal readin4, readin3, readin2, readin1, readin0 : unsigned(3 downto 0);
signal readin4_buf, readin3_buf, readin2_buf, readin1_buf, readin0_buf : unsigned(3 downto 0);

signal one_min, three_min, ten_min : std_logic := '0';
signal clk1s : std_logic;
signal time_up : std_logic := '0';

constant safe_code : unsigned(19 downto 0):="0111" & "0000" & "1001" & "1001" &"0101";  -- 70995
constant digit4 : unsigned(3 downto 0) := "0000";  -- 0
constant digit3 : unsigned(3 downto 0) := "0110";  -- 6
constant digit2 : unsigned(3 downto 0) := "0010";  -- 2
constant digit1 : unsigned(3 downto 0) := "1001";  -- 9
constant digit0 : unsigned(3 downto 0) := "1001";  -- 9
signal combination : unsigned(19 downto 0):=digit4 & digit3 & digit2 & digit1 & digit0;
signal random_digits : unsigned(7 downto 0);
signal random_digit1 : unsigned(3 downto 0);
signal random_digit2 : unsigned(3 downto 0);

begin

    buffer_update:process(clk, reset)
    begin
      if reset = '1' then
         readin4 <= (others=>'0');
         readin3 <= (others=>'0');
         readin2 <= (others=>'0');
         readin1 <= (others=>'0');
         readin0 <= (others=>'0');
      elsif rising_edge(clk) then
         readin4 <= readin4_buf;
         readin3 <= readin3_buf;
         readin2 <= readin2_buf;
         readin1 <= readin1_buf;
         readin0 <= readin0_buf;
      end if;
    end process;
    
    state_update:process(clk, reset)
    begin
        if reset = '1' then
            state <= locked;
        elsif falling_edge(clk) then  -- update behind the buffers after half clk period
            state <= next_state;
        end if;
    end process;
    
    stochastic:process(clk, btn3)
        variable count : integer:=0;
    begin
        if rising_edge(clk) then
            count := count+1;
            if count > 9 then
                count := 0;
            end if;
        end if;
        if btn3='1' then
            segdata3 <= "1100";
            segdata2 <= "1101";
            case count is
            when 0 => random_digit1<=digit4; random_digit2<=digit3; segdata1<="0001"; segdata0<="0010";
            when 1 => random_digit1<=digit4; random_digit2<=digit2; segdata1<="0001"; segdata0<="0011";
            when 2 => random_digit1<=digit4; random_digit2<=digit1; segdata1<="0001"; segdata0<="0100";
            when 3 => random_digit1<=digit4; random_digit2<=digit0; segdata1<="0001"; segdata0<="0101";
            when 4 => random_digit1<=digit3; random_digit2<=digit2; segdata1<="0010"; segdata0<="0011";
            when 5 => random_digit1<=digit3; random_digit2<=digit1; segdata1<="0010"; segdata0<="0100";
            when 6 => random_digit1<=digit3; random_digit2<=digit0; segdata1<="0010"; segdata0<="0101";
            when 7 => random_digit1<=digit2; random_digit2<=digit1; segdata1<="0011"; segdata0<="0100";
            when 8 => random_digit1<=digit2; random_digit2<=digit0; segdata1<="0011"; segdata0<="0101";
            when 9 => random_digit1<=digit1; random_digit2<=digit0; segdata1<="0100"; segdata0<="0101";
            when others => random_digit1<=digit4; random_digit2<=digit0; segdata1<="0001"; segdata0<="0101";
            end case;
        end if;  
    end process;
    random_digits <= random_digit1 & random_digit2;
    
    generate_1hz:process(clk)  -- f_clk=100Mhz
        variable n : integer:= 10;  -- use small n to test instead 100000000
        variable count:integer range n downto 0:=n;
    begin 
        if rising_edge ( clk ) then
            count:=count-1;
            if (count>=n/2) then
                clk1s<='0';
            else
                clk1s<='1';
            end if;
            if count<=0 then
                count:=n;
            end if;
        end if;
    end process;
    
    time_out : process(clk1s, one_min, three_min, ten_min)
        variable count : integer:=0;
    begin
        if one_min='1' then
            if rising_edge(clk1s) then
                count := count + 1 ;
                if count=60 then
                    time_up <= '1';
                    count := 0;
                end if;
            end if;
        elsif three_min='1' then
            if rising_edge(clk1s) then
                count := count + 1 ;
                if count=180 then
                    time_up <= '1';
                    count := 0;
                end if;
            end if;
        elsif ten_min='1' then
            if rising_edge(clk1s) then
                count := count + 1 ;
                if count=600 then
                    time_up <= '1';
                    count := 0;
                end if;
            end if;
        else
            count := 0;
            time_up <= '0';
        end if;
        
    end process;
    
    running:process(reset, btn1, btn2, btn3, time_up)
        variable wrong_cnt : integer;
    begin

-- initialize
        if reset='1' then
            next_state <= locked;
        end if;
        readin4_buf <= readin4;
        readin3_buf <= readin3;
        readin2_buf <= readin2;
        readin1_buf <= readin1;
        readin0_buf <= readin0;

-- transition
        case state is 
        when locked => 
            
            if btn1='1' then
                next_state <= typein4;
            elsif btn3='1' then
                next_state <= typein1;
            end if;
            wrong_cnt := 0;

        when unlocked => 
            wrong_cnt := 0;
            
        when safe => 
            wrong_cnt := 0;
            
        when wait1m => 
            if time_up='1' then
                next_state <= locked;
            end if;

        when wait3m => 
            if time_up='1' then
                next_state <= locked;
            end if;

        when wait10m => 
            if time_up='1' then
                next_state <= locked;
            end if;
            
        when typein4 => 
            if rising_edge(btn2) then
                readin4_buf <= unsigned(sw(3 downto 0));
                next_state <= typein3;
            end if;
           
        when typein3 => 
            if btn1='1' then
                next_state <= typein4;
            elsif rising_edge(btn2) then
                readin3_buf <= unsigned(sw(3 downto 0));
                next_state <= typein2;
            end if;

        when typein2 => 
            if btn1='1' then
                next_state <= typein4;
            elsif rising_edge(btn2) then
                readin2_buf <= unsigned(sw(3 downto 0));
                next_state <= typein1;
            end if;
            
        when typein1 => 
            if btn1='1' then
                next_state <= typein4;
            elsif rising_edge(btn2) then
                readin1_buf <= unsigned(sw(3 downto 0));
                next_state <= typein0;
            end if;
            
        when typein0 => 
            if btn1='1' then
                next_state <= typein4;
            elsif rising_edge(btn2) then
                readin0_buf <= unsigned(sw(3 downto 0));
                next_state <= comparing;
            end if;

        when comparing =>
                if readin_digits=safe_code then
                    next_state <= safe;
                elsif readin_digits=combination or readin_digits2=random_digits then
                    next_state <= unlocked;
                else 
                    if wrong_cnt<5 then 
                        wrong_cnt := wrong_cnt+1; 
                    else 
                        wrong_cnt := 5;
                    end if;
                    
                    case wrong_cnt is
                    when 1 => next_state <= wait1m;  -- use 1 to test instead 3
                    when 4 => next_state <= wait3m;
                    when 5 => next_state <= wait10m;
                    when others=> next_state <= typein4;
                    end case;
                end if;
            
        end case;
        
    end process;
    readin_digits <= readin4 & readin3 & readin2 & readin1 & readin0; 
    readin_digits2 <= readin1 & readin0; 
    
    fsm_ouput: process(state)
    begin
        case state is
        when locked =>
            lock_up <= '1';
            safeMode <= '0';
            one_min <= '0';
            three_min <= '0';
            ten_min <= '0';
        when unlocked => 
            lock_up <= '0';
            safeMode <= '0';
        when safe => 
            lock_up <= '0';
            safeMode <= '1';
        when wait1m =>
            one_min <= '1';
        when wait3m =>
            three_min <= '1';
        when wait10m =>
            three_min <= '1';
        when others =>
            lock_up <= '1';
            safeMode <= '0';
        end case;
    end process;
    
end Behavioral;
