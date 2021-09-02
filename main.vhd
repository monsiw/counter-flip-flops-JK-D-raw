library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is
	Port(
		clk : in std_logic;
		DPSwitch : in  std_logic_vector(1 downto 0) := (others => '0');
		led_segment : out std_logic_vector(7 downto 0) := (others => '0');
		led_enable : out std_logic_vector(2 downto 0) := (others => '0')
	);
end main;

architecture Behavioral of main is
signal D : std_logic_vector(2 downto 0) := (others => '0'); --used trajectory 0->2->4->5->6->0
signal qn : std_logic_vector(2 downto 0) := "001";
signal counter : std_logic_vector(22 downto 0) := (others => '0');
begin
	process (clk) is
	variable J, K : std_logic_vector(qn'range) := (others => '0'); --used trajectory 1->5->3->6->7->1
	begin
	if rising_edge(clk) then		
			if counter = 0 then
				if DPSwitch(1)='1' and DPSwitch(0)='0' then
					D(2) <= D(2) xor D(1);
					D(1) <= D(0) or ((not D(2)) and (not D(1)));
					D(0) <= D(2) and (not D(1)) and (not D(0));					
					led_enable <= not "001";					
					case D is
						when "000" => led_segment <= not "11111100";
						when "010" => led_segment <= not "11011010";
						when "100" => led_segment <= not "01100110";
						when "101" => led_segment <= not "10110110";
						when "110" => led_segment <= not "10111110";
						when others => led_segment <= not "11111111";
					end case;					
				elsif DPSwitch(0)='1' and DPSwitch(1)='0'	then
					J(2) := '1';
					J(1) := qn(2);
					J(0) := '1';
					K(2) := qn(0);
					K(1) := qn(2) and qn(0);
					K(0) := (not qn(2)) and qn(1);					
					led_enable <= not "100";	
					flip_flop_JK : for ii in J'range loop --(another way) for ii in 0 to 2 loop
					  if (J(ii)='0' and K(ii)='0') then
						 qn(ii) <= qn(ii);
					  elsif (J(ii)='0' and K(ii)='1') then
						 qn(ii) <= '0';
					  elsif (J(ii)='1' and K(ii)='0') then
						 qn(ii) <= '1';
					  elsif (J(ii)='1' and K(ii)='1') then
						 qn(ii) <= not qn(ii);
					  end if;
					end loop flip_flop_JK;										
					case qn is
						when "001" => led_segment <= not "01100000";
						when "011" => led_segment <= not "11110010";
						when "101" => led_segment <= not "10110110";
						when "110" => led_segment <= not "10111110";
						when "111" => led_segment <= not "11100000";
						when others => led_segment <= not "11111111";					
					end case;								
				end if;
			end if;
			counter <= (counter + 1); 
	end if;
   end process;			
end Behavioral;