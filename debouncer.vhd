library ieee;
use ieee.std_logic_1164.all;

entity Debouncer is
	port(
		clock: in std_logic;
		reset: in std_logic;
		d_in: in std_logic;
		q_out: out std_logic
	);
end Debouncer;

architecture behavioral of Debouncer is
	signal q1, q2, q3 : std_logic;
begin
	process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				q1 <= '0';
				q2 <= '0';
				q3 <= '0'; 
			else
				q1 <= d_in;
				q2 <= q1;
				q3 <= q2;
			end if;
		end if;
	end process;
	 
	q_out <= q1 and q2 and (not q3);

end behavioral;

