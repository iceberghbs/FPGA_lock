library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;

entity freDiv is
    generic(n:integer:=10); 
    Port (  clock_in : in STD_LOGIC;
            clock_out : out STD_LOGIC
            );
end freDiv;

ARCHITECTURE rtl OF freDiv IS 

BEGIN 
PROCESS (clock_in) 
variable count:integer range n downto 0:=n;
 BEGIN 
IF rising_edge ( clock_in ) THEN 
count:=count-1;
if (count>=n/2) then
    clock_out<='0';
else
    clock_out<='1';
end if;
if count<=0 then
    count:=n;
end if;
 END IF ; 
 END PROCESS ; 
END ARCHITECTURE rtl; 
