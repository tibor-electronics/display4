--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
library ieee;
use ieee.std_logic_1164.all;

entity Timer is
	generic(
		CLOCK_FREQUENCY: positive := 32_000_000;
		TIMER_FREQUENCY: positive := 1_000
	);
	port(
		clock: in std_logic;
		reset: in std_logic;
		tick: out std_logic
	);
end Timer;

architecture behavioral of Timer is
	constant CLOCK_TICKS: integer := (CLOCK_FREQUENCY / TIMER_FREQUENCY) - 1;
	signal tick_count : integer range 0 to CLOCK_TICKS;
begin
	update_clock: process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				tick_count <= 0;
				tick <= '0';
			elsif tick_count = CLOCK_TICKS then
				tick_count <= 0;
				tick <= '1';
			else
				tick_count <= tick_count + 1;
				tick <= '0';
			end if;
		end if;
	end process;

end behavioral;
