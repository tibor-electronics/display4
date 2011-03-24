--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
-- Based on code from:
-- http://www.labbookpages.co.uk/electronics/debounce.html
--
library ieee;
use ieee.std_logic_1164.all;

entity Debouncer is
	generic(
		CLOCK_FREQUENCY: positive := 32_000_000;
		SAMPLE_FREQUENCY: positive := 2000; -- 500us
		SAMPLE_COUNT: positive := 20
	);
	port(
		clock: in std_logic;
		reset: in std_logic;
		d_in: in std_logic;
		d_out: out std_logic
	);
end Debouncer;

architecture behavioral of Debouncer is
	component Timer is
		generic(
			CLOCK_FREQUENCY: positive;
			TIMER_FREQUENCY: positive
		);
		port(
			clock: in std_logic;
			reset: in std_logic;
			tick: out std_logic
		);
	end component;
	
	signal sample_tick : std_logic;
	signal sync : std_logic_vector(1 downto 0);
	signal sample_count : integer range 0 to SAMPLE_COUNT;
begin
	sample_clock: Timer
		generic map(
			CLOCK_FREQUENCY => CLOCK_FREQUENCY,
			TIMER_FREQUENCY => SAMPLE_FREQUENCY
		)
		port map(
			clock => clock,
			reset => reset,
			tick => sample_tick
		);
	
	debounce: process(clock)
	begin
		if clock'event and clock = '1' then
			if reset = '1' then
				sync <= (others => '0');
				sample_count <= 0;
				d_out <= '0';
			else
				sync <= sync(0) & d_in;
				
				if sync(1) = '0' then
					sample_count <= 0;
					d_out <= '0';
				elsif sample_tick = '1' then
					if sample_count = SAMPLE_COUNT then
						d_out <= '1';
					else
						sample_count <= sample_count + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
end behavioral;
