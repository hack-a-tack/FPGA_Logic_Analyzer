-- ******************************************************************************

-- iCEcube Netlister

-- Version:            2020.12.27943

-- Build Date:         Dec  9 2020 18:18:06

-- File Generated:     Mar 7 2026 11:21:32

-- Purpose:            Post-Route Verilog/VHDL netlist for timing simulation

-- Copyright (C) 2006-2010 by Lattice Semiconductor Corp. All rights reserved.

-- ******************************************************************************

-- VHDL file for cell "send_engine" view "INTERFACE"

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library ice;
use ice.vcomponent_vital.all;

-- Entity of send_engine
entity send_engine is
port (
    o_send_tx_byte : out std_logic_vector(7 downto 0);
    o_ram_rd_addr : out std_logic_vector(11 downto 0);
    i_ram_rd_data : in std_logic_vector(7 downto 0);
    o_send_tx_start_pulse : out std_logic;
    i_send_start_pulse : in std_logic;
    o_send_done_pulse : out std_logic;
    i_clk : in std_logic;
    i_rst : in std_logic;
    i_tx_busy : in std_logic);
end send_engine;

-- Architecture of send_engine
-- View name is \INTERFACE\
architecture \INTERFACE\ of send_engine is

signal \N__2143\ : std_logic;
signal \N__2142\ : std_logic;
signal \N__2141\ : std_logic;
signal \N__2132\ : std_logic;
signal \N__2131\ : std_logic;
signal \N__2130\ : std_logic;
signal \N__2123\ : std_logic;
signal \N__2122\ : std_logic;
signal \N__2121\ : std_logic;
signal \N__2114\ : std_logic;
signal \N__2113\ : std_logic;
signal \N__2112\ : std_logic;
signal \N__2105\ : std_logic;
signal \N__2104\ : std_logic;
signal \N__2103\ : std_logic;
signal \N__2096\ : std_logic;
signal \N__2095\ : std_logic;
signal \N__2094\ : std_logic;
signal \N__2087\ : std_logic;
signal \N__2086\ : std_logic;
signal \N__2085\ : std_logic;
signal \N__2078\ : std_logic;
signal \N__2077\ : std_logic;
signal \N__2076\ : std_logic;
signal \N__2069\ : std_logic;
signal \N__2068\ : std_logic;
signal \N__2067\ : std_logic;
signal \N__2060\ : std_logic;
signal \N__2059\ : std_logic;
signal \N__2058\ : std_logic;
signal \N__2051\ : std_logic;
signal \N__2050\ : std_logic;
signal \N__2049\ : std_logic;
signal \N__2042\ : std_logic;
signal \N__2041\ : std_logic;
signal \N__2040\ : std_logic;
signal \N__2033\ : std_logic;
signal \N__2032\ : std_logic;
signal \N__2031\ : std_logic;
signal \N__2024\ : std_logic;
signal \N__2023\ : std_logic;
signal \N__2022\ : std_logic;
signal \N__2015\ : std_logic;
signal \N__2014\ : std_logic;
signal \N__2013\ : std_logic;
signal \N__2006\ : std_logic;
signal \N__2005\ : std_logic;
signal \N__2004\ : std_logic;
signal \N__1997\ : std_logic;
signal \N__1996\ : std_logic;
signal \N__1995\ : std_logic;
signal \N__1988\ : std_logic;
signal \N__1987\ : std_logic;
signal \N__1986\ : std_logic;
signal \N__1979\ : std_logic;
signal \N__1978\ : std_logic;
signal \N__1977\ : std_logic;
signal \N__1970\ : std_logic;
signal \N__1969\ : std_logic;
signal \N__1968\ : std_logic;
signal \N__1961\ : std_logic;
signal \N__1960\ : std_logic;
signal \N__1959\ : std_logic;
signal \N__1952\ : std_logic;
signal \N__1951\ : std_logic;
signal \N__1950\ : std_logic;
signal \N__1943\ : std_logic;
signal \N__1942\ : std_logic;
signal \N__1941\ : std_logic;
signal \N__1934\ : std_logic;
signal \N__1933\ : std_logic;
signal \N__1932\ : std_logic;
signal \N__1925\ : std_logic;
signal \N__1924\ : std_logic;
signal \N__1923\ : std_logic;
signal \N__1916\ : std_logic;
signal \N__1915\ : std_logic;
signal \N__1914\ : std_logic;
signal \N__1907\ : std_logic;
signal \N__1906\ : std_logic;
signal \N__1905\ : std_logic;
signal \N__1898\ : std_logic;
signal \N__1897\ : std_logic;
signal \N__1896\ : std_logic;
signal \N__1889\ : std_logic;
signal \N__1888\ : std_logic;
signal \N__1887\ : std_logic;
signal \N__1880\ : std_logic;
signal \N__1879\ : std_logic;
signal \N__1878\ : std_logic;
signal \N__1871\ : std_logic;
signal \N__1870\ : std_logic;
signal \N__1869\ : std_logic;
signal \N__1862\ : std_logic;
signal \N__1861\ : std_logic;
signal \N__1860\ : std_logic;
signal \N__1853\ : std_logic;
signal \N__1852\ : std_logic;
signal \N__1851\ : std_logic;
signal \N__1844\ : std_logic;
signal \N__1843\ : std_logic;
signal \N__1842\ : std_logic;
signal \N__1825\ : std_logic;
signal \N__1822\ : std_logic;
signal \N__1819\ : std_logic;
signal \N__1816\ : std_logic;
signal \N__1813\ : std_logic;
signal \N__1812\ : std_logic;
signal \N__1811\ : std_logic;
signal \N__1808\ : std_logic;
signal \N__1805\ : std_logic;
signal \N__1802\ : std_logic;
signal \N__1795\ : std_logic;
signal \N__1792\ : std_logic;
signal \N__1789\ : std_logic;
signal \N__1786\ : std_logic;
signal \N__1783\ : std_logic;
signal \N__1780\ : std_logic;
signal \N__1779\ : std_logic;
signal \N__1778\ : std_logic;
signal \N__1777\ : std_logic;
signal \N__1774\ : std_logic;
signal \N__1771\ : std_logic;
signal \N__1766\ : std_logic;
signal \N__1759\ : std_logic;
signal \N__1756\ : std_logic;
signal \N__1753\ : std_logic;
signal \N__1750\ : std_logic;
signal \N__1749\ : std_logic;
signal \N__1748\ : std_logic;
signal \N__1747\ : std_logic;
signal \N__1744\ : std_logic;
signal \N__1741\ : std_logic;
signal \N__1736\ : std_logic;
signal \N__1729\ : std_logic;
signal \N__1726\ : std_logic;
signal \N__1723\ : std_logic;
signal \N__1720\ : std_logic;
signal \N__1719\ : std_logic;
signal \N__1716\ : std_logic;
signal \N__1715\ : std_logic;
signal \N__1714\ : std_logic;
signal \N__1711\ : std_logic;
signal \N__1708\ : std_logic;
signal \N__1705\ : std_logic;
signal \N__1702\ : std_logic;
signal \N__1699\ : std_logic;
signal \N__1690\ : std_logic;
signal \N__1687\ : std_logic;
signal \N__1684\ : std_logic;
signal \N__1681\ : std_logic;
signal \N__1678\ : std_logic;
signal \N__1675\ : std_logic;
signal \N__1674\ : std_logic;
signal \N__1673\ : std_logic;
signal \N__1672\ : std_logic;
signal \N__1669\ : std_logic;
signal \N__1666\ : std_logic;
signal \N__1663\ : std_logic;
signal \N__1660\ : std_logic;
signal \N__1651\ : std_logic;
signal \N__1650\ : std_logic;
signal \N__1649\ : std_logic;
signal \N__1648\ : std_logic;
signal \N__1647\ : std_logic;
signal \N__1636\ : std_logic;
signal \N__1633\ : std_logic;
signal \N__1630\ : std_logic;
signal \N__1629\ : std_logic;
signal \N__1626\ : std_logic;
signal \N__1623\ : std_logic;
signal \N__1618\ : std_logic;
signal \N__1615\ : std_logic;
signal \N__1612\ : std_logic;
signal \N__1609\ : std_logic;
signal \N__1606\ : std_logic;
signal \N__1603\ : std_logic;
signal \N__1602\ : std_logic;
signal \N__1601\ : std_logic;
signal \N__1600\ : std_logic;
signal \N__1597\ : std_logic;
signal \N__1594\ : std_logic;
signal \N__1589\ : std_logic;
signal \N__1586\ : std_logic;
signal \N__1579\ : std_logic;
signal \N__1576\ : std_logic;
signal \N__1575\ : std_logic;
signal \N__1574\ : std_logic;
signal \N__1571\ : std_logic;
signal \N__1568\ : std_logic;
signal \N__1565\ : std_logic;
signal \N__1558\ : std_logic;
signal \N__1555\ : std_logic;
signal \N__1552\ : std_logic;
signal \N__1551\ : std_logic;
signal \N__1548\ : std_logic;
signal \N__1547\ : std_logic;
signal \N__1544\ : std_logic;
signal \N__1541\ : std_logic;
signal \N__1538\ : std_logic;
signal \N__1535\ : std_logic;
signal \N__1528\ : std_logic;
signal \N__1525\ : std_logic;
signal \N__1522\ : std_logic;
signal \N__1519\ : std_logic;
signal \N__1516\ : std_logic;
signal \N__1515\ : std_logic;
signal \N__1514\ : std_logic;
signal \N__1511\ : std_logic;
signal \N__1508\ : std_logic;
signal \N__1505\ : std_logic;
signal \N__1498\ : std_logic;
signal \N__1495\ : std_logic;
signal \N__1492\ : std_logic;
signal \N__1489\ : std_logic;
signal \N__1486\ : std_logic;
signal \N__1485\ : std_logic;
signal \N__1484\ : std_logic;
signal \N__1481\ : std_logic;
signal \N__1478\ : std_logic;
signal \N__1475\ : std_logic;
signal \N__1468\ : std_logic;
signal \N__1465\ : std_logic;
signal \N__1462\ : std_logic;
signal \N__1459\ : std_logic;
signal \N__1458\ : std_logic;
signal \N__1457\ : std_logic;
signal \N__1454\ : std_logic;
signal \N__1451\ : std_logic;
signal \N__1448\ : std_logic;
signal \N__1441\ : std_logic;
signal \N__1438\ : std_logic;
signal \N__1435\ : std_logic;
signal \N__1434\ : std_logic;
signal \N__1431\ : std_logic;
signal \N__1428\ : std_logic;
signal \N__1427\ : std_logic;
signal \N__1424\ : std_logic;
signal \N__1421\ : std_logic;
signal \N__1418\ : std_logic;
signal \N__1413\ : std_logic;
signal \N__1408\ : std_logic;
signal \N__1405\ : std_logic;
signal \N__1402\ : std_logic;
signal \N__1399\ : std_logic;
signal \N__1396\ : std_logic;
signal \N__1395\ : std_logic;
signal \N__1394\ : std_logic;
signal \N__1391\ : std_logic;
signal \N__1388\ : std_logic;
signal \N__1385\ : std_logic;
signal \N__1378\ : std_logic;
signal \N__1375\ : std_logic;
signal \N__1374\ : std_logic;
signal \N__1371\ : std_logic;
signal \N__1368\ : std_logic;
signal \N__1363\ : std_logic;
signal \N__1360\ : std_logic;
signal \N__1357\ : std_logic;
signal \N__1354\ : std_logic;
signal \N__1353\ : std_logic;
signal \N__1348\ : std_logic;
signal \N__1345\ : std_logic;
signal \N__1342\ : std_logic;
signal \N__1339\ : std_logic;
signal \N__1336\ : std_logic;
signal \N__1333\ : std_logic;
signal \N__1332\ : std_logic;
signal \N__1329\ : std_logic;
signal \N__1328\ : std_logic;
signal \N__1327\ : std_logic;
signal \N__1326\ : std_logic;
signal \N__1325\ : std_logic;
signal \N__1324\ : std_logic;
signal \N__1311\ : std_logic;
signal \N__1308\ : std_logic;
signal \N__1303\ : std_logic;
signal \N__1300\ : std_logic;
signal \N__1297\ : std_logic;
signal \N__1294\ : std_logic;
signal \N__1293\ : std_logic;
signal \N__1292\ : std_logic;
signal \N__1291\ : std_logic;
signal \N__1290\ : std_logic;
signal \N__1285\ : std_logic;
signal \N__1278\ : std_logic;
signal \N__1275\ : std_logic;
signal \N__1270\ : std_logic;
signal \N__1267\ : std_logic;
signal \N__1264\ : std_logic;
signal \N__1261\ : std_logic;
signal \N__1260\ : std_logic;
signal \N__1259\ : std_logic;
signal \N__1258\ : std_logic;
signal \N__1257\ : std_logic;
signal \N__1256\ : std_logic;
signal \N__1255\ : std_logic;
signal \N__1254\ : std_logic;
signal \N__1237\ : std_logic;
signal \N__1236\ : std_logic;
signal \N__1235\ : std_logic;
signal \N__1234\ : std_logic;
signal \N__1233\ : std_logic;
signal \N__1230\ : std_logic;
signal \N__1225\ : std_logic;
signal \N__1220\ : std_logic;
signal \N__1213\ : std_logic;
signal \N__1212\ : std_logic;
signal \N__1209\ : std_logic;
signal \N__1208\ : std_logic;
signal \N__1207\ : std_logic;
signal \N__1204\ : std_logic;
signal \N__1203\ : std_logic;
signal \N__1202\ : std_logic;
signal \N__1201\ : std_logic;
signal \N__1200\ : std_logic;
signal \N__1197\ : std_logic;
signal \N__1186\ : std_logic;
signal \N__1181\ : std_logic;
signal \N__1174\ : std_logic;
signal \N__1173\ : std_logic;
signal \N__1170\ : std_logic;
signal \N__1167\ : std_logic;
signal \N__1162\ : std_logic;
signal \N__1159\ : std_logic;
signal \N__1156\ : std_logic;
signal \N__1153\ : std_logic;
signal \N__1150\ : std_logic;
signal \N__1147\ : std_logic;
signal \N__1144\ : std_logic;
signal \N__1141\ : std_logic;
signal \N__1138\ : std_logic;
signal \N__1135\ : std_logic;
signal \N__1132\ : std_logic;
signal \N__1129\ : std_logic;
signal \N__1126\ : std_logic;
signal \N__1123\ : std_logic;
signal \N__1120\ : std_logic;
signal \N__1117\ : std_logic;
signal \N__1114\ : std_logic;
signal \N__1111\ : std_logic;
signal \N__1108\ : std_logic;
signal \N__1105\ : std_logic;
signal \N__1102\ : std_logic;
signal \N__1101\ : std_logic;
signal \N__1100\ : std_logic;
signal \N__1099\ : std_logic;
signal \N__1098\ : std_logic;
signal \N__1097\ : std_logic;
signal \N__1096\ : std_logic;
signal \N__1095\ : std_logic;
signal \N__1094\ : std_logic;
signal \N__1093\ : std_logic;
signal \N__1088\ : std_logic;
signal \N__1079\ : std_logic;
signal \N__1070\ : std_logic;
signal \N__1063\ : std_logic;
signal \N__1062\ : std_logic;
signal \N__1057\ : std_logic;
signal \N__1054\ : std_logic;
signal \N__1053\ : std_logic;
signal \N__1048\ : std_logic;
signal \N__1045\ : std_logic;
signal \N__1042\ : std_logic;
signal \N__1039\ : std_logic;
signal \N__1036\ : std_logic;
signal \N__1033\ : std_logic;
signal \N__1030\ : std_logic;
signal \N__1027\ : std_logic;
signal \N__1024\ : std_logic;
signal \N__1021\ : std_logic;
signal \N__1018\ : std_logic;
signal \N__1015\ : std_logic;
signal \N__1012\ : std_logic;
signal \N__1009\ : std_logic;
signal \N__1006\ : std_logic;
signal \N__1003\ : std_logic;
signal \N__1000\ : std_logic;
signal \N__997\ : std_logic;
signal \N__994\ : std_logic;
signal \N__991\ : std_logic;
signal \N__988\ : std_logic;
signal \N__985\ : std_logic;
signal \N__982\ : std_logic;
signal \N__979\ : std_logic;
signal \N__976\ : std_logic;
signal \N__973\ : std_logic;
signal \N__970\ : std_logic;
signal \N__967\ : std_logic;
signal \N__964\ : std_logic;
signal \N__961\ : std_logic;
signal \N__958\ : std_logic;
signal \N__955\ : std_logic;
signal \N__952\ : std_logic;
signal \N__949\ : std_logic;
signal \N__946\ : std_logic;
signal \N__943\ : std_logic;
signal \N__940\ : std_logic;
signal \N__937\ : std_logic;
signal \N__934\ : std_logic;
signal \N__931\ : std_logic;
signal \N__928\ : std_logic;
signal \N__925\ : std_logic;
signal \N__922\ : std_logic;
signal \N__919\ : std_logic;
signal \N__916\ : std_logic;
signal \N__913\ : std_logic;
signal \N__910\ : std_logic;
signal \N__907\ : std_logic;
signal \N__904\ : std_logic;
signal \N__901\ : std_logic;
signal \N__898\ : std_logic;
signal \N__895\ : std_logic;
signal \N__892\ : std_logic;
signal \N__889\ : std_logic;
signal \N__886\ : std_logic;
signal \N__883\ : std_logic;
signal \N__880\ : std_logic;
signal \N__877\ : std_logic;
signal \N__874\ : std_logic;
signal \N__871\ : std_logic;
signal \GNDG0\ : std_logic;
signal \VCCG0\ : std_logic;
signal i_ram_rd_data_c_5 : std_logic;
signal o_send_tx_byte_c_5 : std_logic;
signal i_ram_rd_data_c_2 : std_logic;
signal o_send_tx_byte_c_2 : std_logic;
signal i_ram_rd_data_c_7 : std_logic;
signal o_send_tx_byte_c_7 : std_logic;
signal i_ram_rd_data_c_3 : std_logic;
signal o_send_tx_byte_c_3 : std_logic;
signal i_ram_rd_data_c_6 : std_logic;
signal o_send_tx_byte_c_6 : std_logic;
signal i_ram_rd_data_c_0 : std_logic;
signal o_send_tx_byte_c_0 : std_logic;
signal i_ram_rd_data_c_1 : std_logic;
signal o_send_tx_byte_c_1 : std_logic;
signal i_ram_rd_data_c_4 : std_logic;
signal o_send_tx_byte_c_4 : std_logic;
signal \N_13_i_0\ : std_logic;
signal o_send_tx_start_pulse_c : std_logic;
signal \N_18_cascade_\ : std_logic;
signal \r_stateZ0Z_0\ : std_logic;
signal \N_18\ : std_logic;
signal \r_state_fastZ0Z_0\ : std_logic;
signal o_send_done_pulse_c : std_logic;
signal i_send_start_pulse_c : std_logic;
signal r_state_ns_i_i_a2_0_6_1 : std_logic;
signal r_state_ns_i_i_a2_0_7_1 : std_logic;
signal \r_state_ns_i_i_a2_0_6_1_cascade_\ : std_logic;
signal \r_ram_rd_addr_RNIDTLB3Z0Z_11_cascade_\ : std_logic;
signal r_ram_rd_addr_66_1 : std_logic;
signal i_tx_busy_c : std_logic;
signal \r_state_0_repZ0Z1\ : std_logic;
signal \r_state_RNO_0Z0Z_1_cascade_\ : std_logic;
signal \r_ram_rd_addr_RNIDTLB3Z0Z_11\ : std_logic;
signal \r_stateZ0Z_1\ : std_logic;
signal i_rst_c : std_logic;
signal \n_state_5_sqmuxa_0_a3_0_a2_0_cascade_\ : std_logic;
signal n_state_5_sqmuxa_0_a3_0_a2_9 : std_logic;
signal r_state_ns_i_i_a2_0_8_1 : std_logic;
signal n_send_tx_byte_0_sqmuxa : std_logic;
signal o_ram_rd_addr_c_0 : std_logic;
signal \bfn_2_10_0_\ : std_logic;
signal o_ram_rd_addr_c_1 : std_logic;
signal un1_r_ram_rd_addr_cry_0 : std_logic;
signal o_ram_rd_addr_c_2 : std_logic;
signal un1_r_ram_rd_addr_cry_1 : std_logic;
signal o_ram_rd_addr_c_3 : std_logic;
signal un1_r_ram_rd_addr_cry_2 : std_logic;
signal o_ram_rd_addr_c_4 : std_logic;
signal un1_r_ram_rd_addr_cry_3 : std_logic;
signal o_ram_rd_addr_c_5 : std_logic;
signal un1_r_ram_rd_addr_cry_4 : std_logic;
signal o_ram_rd_addr_c_6 : std_logic;
signal un1_r_ram_rd_addr_cry_5 : std_logic;
signal o_ram_rd_addr_c_7 : std_logic;
signal un1_r_ram_rd_addr_cry_6 : std_logic;
signal un1_r_ram_rd_addr_cry_7 : std_logic;
signal o_ram_rd_addr_c_8 : std_logic;
signal \bfn_2_11_0_\ : std_logic;
signal o_ram_rd_addr_c_9 : std_logic;
signal un1_r_ram_rd_addr_cry_8 : std_logic;
signal o_ram_rd_addr_c_10 : std_logic;
signal un1_r_ram_rd_addr_cry_9 : std_logic;
signal un1_r_ram_rd_addr_cry_10 : std_logic;
signal o_ram_rd_addr_c_11 : std_logic;
signal \_gnd_net_\ : std_logic;
signal i_clk_c_g : std_logic;
signal \r_state_RNIIB3C4Z0Z_1\ : std_logic;

signal i_clk_wire : std_logic;
signal o_ram_rd_addr_wire : std_logic_vector(11 downto 0);
signal i_ram_rd_data_wire : std_logic_vector(7 downto 0);
signal o_send_tx_byte_wire : std_logic_vector(7 downto 0);
signal i_rst_wire : std_logic;
signal o_send_tx_start_pulse_wire : std_logic;
signal i_send_start_pulse_wire : std_logic;
signal o_send_done_pulse_wire : std_logic;
signal i_tx_busy_wire : std_logic;

begin
    i_clk_wire <= i_clk;
    o_ram_rd_addr <= o_ram_rd_addr_wire;
    i_ram_rd_data_wire <= i_ram_rd_data;
    o_send_tx_byte <= o_send_tx_byte_wire;
    i_rst_wire <= i_rst;
    o_send_tx_start_pulse <= o_send_tx_start_pulse_wire;
    i_send_start_pulse_wire <= i_send_start_pulse;
    o_send_done_pulse <= o_send_done_pulse_wire;
    i_tx_busy_wire <= i_tx_busy;

    \i_clk_ibuf_gb_io_preiogbuf\ : PRE_IO_GBUF
    port map (
            PADSIGNALTOGLOBALBUFFER => \N__2141\,
            GLOBALBUFFEROUTPUT => i_clk_c_g
        );

    \i_clk_ibuf_gb_io_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2143\,
            DIN => \N__2142\,
            DOUT => \N__2141\,
            PACKAGEPIN => i_clk_wire
        );

    \i_clk_ibuf_gb_io_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__2143\,
            PADOUT => \N__2142\,
            PADIN => \N__2141\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2132\,
            DIN => \N__2131\,
            DOUT => \N__2130\,
            PACKAGEPIN => o_ram_rd_addr_wire(1)
        );

    \o_ram_rd_addr_obuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2132\,
            PADOUT => \N__2131\,
            PADIN => \N__2130\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1558\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2123\,
            DIN => \N__2122\,
            DOUT => \N__2121\,
            PACKAGEPIN => i_ram_rd_data_wire(6)
        );

    \i_ram_rd_data_ibuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__2123\,
            PADOUT => \N__2122\,
            PADIN => \N__2121\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_6,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2114\,
            DIN => \N__2113\,
            DOUT => \N__2112\,
            PACKAGEPIN => o_send_tx_byte_wire(2)
        );

    \o_send_tx_byte_obuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2114\,
            PADOUT => \N__2113\,
            PADIN => \N__2112\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__994\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2105\,
            DIN => \N__2104\,
            DOUT => \N__2103\,
            PACKAGEPIN => o_ram_rd_addr_wire(6)
        );

    \o_ram_rd_addr_obuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2105\,
            PADOUT => \N__2104\,
            PADIN => \N__2103\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1405\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2096\,
            DIN => \N__2095\,
            DOUT => \N__2094\,
            PACKAGEPIN => i_ram_rd_data_wire(1)
        );

    \i_ram_rd_data_ibuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__2096\,
            PADOUT => \N__2095\,
            PADIN => \N__2094\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_1,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2087\,
            DIN => \N__2086\,
            DOUT => \N__2085\,
            PACKAGEPIN => o_send_tx_byte_wire(5)
        );

    \o_send_tx_byte_obuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2087\,
            PADOUT => \N__2086\,
            PADIN => \N__2085\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1021\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_11_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2078\,
            DIN => \N__2077\,
            DOUT => \N__2076\,
            PACKAGEPIN => o_ram_rd_addr_wire(11)
        );

    \o_ram_rd_addr_obuf_11_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2078\,
            PADOUT => \N__2077\,
            PADIN => \N__2076\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1684\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2069\,
            DIN => \N__2068\,
            DOUT => \N__2067\,
            PACKAGEPIN => o_ram_rd_addr_wire(2)
        );

    \o_ram_rd_addr_obuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2069\,
            PADOUT => \N__2068\,
            PADIN => \N__2067\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1525\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2060\,
            DIN => \N__2059\,
            DOUT => \N__2058\,
            PACKAGEPIN => i_ram_rd_data_wire(5)
        );

    \i_ram_rd_data_ibuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__2060\,
            PADOUT => \N__2059\,
            PADIN => \N__2058\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_5,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2051\,
            DIN => \N__2050\,
            DOUT => \N__2049\,
            PACKAGEPIN => o_send_tx_byte_wire(1)
        );

    \o_send_tx_byte_obuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2051\,
            PADOUT => \N__2050\,
            PADIN => \N__2049\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1162\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2042\,
            DIN => \N__2041\,
            DOUT => \N__2040\,
            PACKAGEPIN => o_ram_rd_addr_wire(7)
        );

    \o_ram_rd_addr_obuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2042\,
            PADOUT => \N__2041\,
            PADIN => \N__2040\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1825\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2033\,
            DIN => \N__2032\,
            DOUT => \N__2031\,
            PACKAGEPIN => i_ram_rd_data_wire(0)
        );

    \i_ram_rd_data_ibuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__2033\,
            PADOUT => \N__2032\,
            PADIN => \N__2031\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_0,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2024\,
            DIN => \N__2023\,
            DOUT => \N__2022\,
            PACKAGEPIN => o_send_tx_byte_wire(4)
        );

    \o_send_tx_byte_obuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2024\,
            PADOUT => \N__2023\,
            PADIN => \N__2022\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1135\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_rst_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2015\,
            DIN => \N__2014\,
            DOUT => \N__2013\,
            PACKAGEPIN => i_rst_wire
        );

    \i_rst_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__2015\,
            PADOUT => \N__2014\,
            PADIN => \N__2013\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_rst_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_10_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__2006\,
            DIN => \N__2005\,
            DOUT => \N__2004\,
            PACKAGEPIN => o_ram_rd_addr_wire(10)
        );

    \o_ram_rd_addr_obuf_10_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__2006\,
            PADOUT => \N__2005\,
            PADIN => \N__2004\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1726\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1997\,
            DIN => \N__1996\,
            DOUT => \N__1995\,
            PACKAGEPIN => o_ram_rd_addr_wire(5)
        );

    \o_ram_rd_addr_obuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1997\,
            PADOUT => \N__1996\,
            PADIN => \N__1995\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1438\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1988\,
            DIN => \N__1987\,
            DOUT => \N__1986\,
            PACKAGEPIN => i_ram_rd_data_wire(2)
        );

    \i_ram_rd_data_ibuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1988\,
            PADOUT => \N__1987\,
            PADIN => \N__1986\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_2,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1979\,
            DIN => \N__1978\,
            DOUT => \N__1977\,
            PACKAGEPIN => o_send_tx_byte_wire(6)
        );

    \o_send_tx_byte_obuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1979\,
            PADOUT => \N__1978\,
            PADIN => \N__1977\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__913\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1970\,
            DIN => \N__1969\,
            DOUT => \N__1968\,
            PACKAGEPIN => o_ram_rd_addr_wire(3)
        );

    \o_ram_rd_addr_obuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1970\,
            PADOUT => \N__1969\,
            PADIN => \N__1968\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1495\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1961\,
            DIN => \N__1960\,
            DOUT => \N__1959\,
            PACKAGEPIN => i_ram_rd_data_wire(4)
        );

    \i_ram_rd_data_ibuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1961\,
            PADOUT => \N__1960\,
            PADIN => \N__1959\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_4,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1952\,
            DIN => \N__1951\,
            DOUT => \N__1950\,
            PACKAGEPIN => o_send_tx_byte_wire(0)
        );

    \o_send_tx_byte_obuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1952\,
            PADOUT => \N__1951\,
            PADIN => \N__1950\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__892\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_8_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1943\,
            DIN => \N__1942\,
            DOUT => \N__1941\,
            PACKAGEPIN => o_ram_rd_addr_wire(8)
        );

    \o_ram_rd_addr_obuf_8_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1943\,
            PADOUT => \N__1942\,
            PADIN => \N__1941\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1792\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_start_pulse_obuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1934\,
            DIN => \N__1933\,
            DOUT => \N__1932\,
            PACKAGEPIN => o_send_tx_start_pulse_wire
        );

    \o_send_tx_start_pulse_obuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1934\,
            PADOUT => \N__1933\,
            PADIN => \N__1932\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1111\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1925\,
            DIN => \N__1924\,
            DOUT => \N__1923\,
            PACKAGEPIN => o_ram_rd_addr_wire(4)
        );

    \o_ram_rd_addr_obuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1925\,
            PADOUT => \N__1924\,
            PADIN => \N__1923\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1465\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1916\,
            DIN => \N__1915\,
            DOUT => \N__1914\,
            PACKAGEPIN => i_ram_rd_data_wire(3)
        );

    \i_ram_rd_data_ibuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1916\,
            PADOUT => \N__1915\,
            PADIN => \N__1914\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_3,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_start_pulse_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1907\,
            DIN => \N__1906\,
            DOUT => \N__1905\,
            PACKAGEPIN => i_send_start_pulse_wire
        );

    \i_send_start_pulse_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1907\,
            PADOUT => \N__1906\,
            PADIN => \N__1905\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_start_pulse_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_done_pulse_obuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1898\,
            DIN => \N__1897\,
            DOUT => \N__1896\,
            PACKAGEPIN => o_send_done_pulse_wire
        );

    \o_send_done_pulse_obuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1898\,
            PADOUT => \N__1897\,
            PADIN => \N__1896\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1045\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1889\,
            DIN => \N__1888\,
            DOUT => \N__1887\,
            PACKAGEPIN => o_send_tx_byte_wire(7)
        );

    \o_send_tx_byte_obuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1889\,
            PADOUT => \N__1888\,
            PADIN => \N__1887\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__964\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_9_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1880\,
            DIN => \N__1879\,
            DOUT => \N__1878\,
            PACKAGEPIN => o_ram_rd_addr_wire(9)
        );

    \o_ram_rd_addr_obuf_9_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1880\,
            PADOUT => \N__1879\,
            PADIN => \N__1878\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1756\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_ram_rd_addr_obuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1871\,
            DIN => \N__1870\,
            DOUT => \N__1869\,
            PACKAGEPIN => o_ram_rd_addr_wire(0)
        );

    \o_ram_rd_addr_obuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1871\,
            PADOUT => \N__1870\,
            PADIN => \N__1869\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__1579\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_ram_rd_data_ibuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1862\,
            DIN => \N__1861\,
            DOUT => \N__1860\,
            PACKAGEPIN => i_ram_rd_data_wire(7)
        );

    \i_ram_rd_data_ibuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1862\,
            PADOUT => \N__1861\,
            PADIN => \N__1860\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_ram_rd_data_c_7,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_tx_busy_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1853\,
            DIN => \N__1852\,
            DOUT => \N__1851\,
            PACKAGEPIN => i_tx_busy_wire
        );

    \i_tx_busy_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1853\,
            PADOUT => \N__1852\,
            PADIN => \N__1851\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_tx_busy_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_tx_byte_obuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1844\,
            DIN => \N__1843\,
            DOUT => \N__1842\,
            PACKAGEPIN => o_send_tx_byte_wire(3)
        );

    \o_send_tx_byte_obuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1844\,
            PADOUT => \N__1843\,
            PADIN => \N__1842\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__943\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \I__395\ : IoInMux
    port map (
            O => \N__1825\,
            I => \N__1822\
        );

    \I__394\ : LocalMux
    port map (
            O => \N__1822\,
            I => \N__1819\
        );

    \I__393\ : IoSpan4Mux
    port map (
            O => \N__1819\,
            I => \N__1816\
        );

    \I__392\ : Span4Mux_s2_v
    port map (
            O => \N__1816\,
            I => \N__1813\
        );

    \I__391\ : Span4Mux_v
    port map (
            O => \N__1813\,
            I => \N__1808\
        );

    \I__390\ : InMux
    port map (
            O => \N__1812\,
            I => \N__1805\
        );

    \I__389\ : InMux
    port map (
            O => \N__1811\,
            I => \N__1802\
        );

    \I__388\ : Odrv4
    port map (
            O => \N__1808\,
            I => o_ram_rd_addr_c_7
        );

    \I__387\ : LocalMux
    port map (
            O => \N__1805\,
            I => o_ram_rd_addr_c_7
        );

    \I__386\ : LocalMux
    port map (
            O => \N__1802\,
            I => o_ram_rd_addr_c_7
        );

    \I__385\ : InMux
    port map (
            O => \N__1795\,
            I => un1_r_ram_rd_addr_cry_6
        );

    \I__384\ : IoInMux
    port map (
            O => \N__1792\,
            I => \N__1789\
        );

    \I__383\ : LocalMux
    port map (
            O => \N__1789\,
            I => \N__1786\
        );

    \I__382\ : IoSpan4Mux
    port map (
            O => \N__1786\,
            I => \N__1783\
        );

    \I__381\ : Span4Mux_s1_v
    port map (
            O => \N__1783\,
            I => \N__1780\
        );

    \I__380\ : Span4Mux_v
    port map (
            O => \N__1780\,
            I => \N__1774\
        );

    \I__379\ : InMux
    port map (
            O => \N__1779\,
            I => \N__1771\
        );

    \I__378\ : InMux
    port map (
            O => \N__1778\,
            I => \N__1766\
        );

    \I__377\ : InMux
    port map (
            O => \N__1777\,
            I => \N__1766\
        );

    \I__376\ : Odrv4
    port map (
            O => \N__1774\,
            I => o_ram_rd_addr_c_8
        );

    \I__375\ : LocalMux
    port map (
            O => \N__1771\,
            I => o_ram_rd_addr_c_8
        );

    \I__374\ : LocalMux
    port map (
            O => \N__1766\,
            I => o_ram_rd_addr_c_8
        );

    \I__373\ : InMux
    port map (
            O => \N__1759\,
            I => \bfn_2_11_0_\
        );

    \I__372\ : IoInMux
    port map (
            O => \N__1756\,
            I => \N__1753\
        );

    \I__371\ : LocalMux
    port map (
            O => \N__1753\,
            I => \N__1750\
        );

    \I__370\ : Span12Mux_s5_v
    port map (
            O => \N__1750\,
            I => \N__1744\
        );

    \I__369\ : InMux
    port map (
            O => \N__1749\,
            I => \N__1741\
        );

    \I__368\ : InMux
    port map (
            O => \N__1748\,
            I => \N__1736\
        );

    \I__367\ : InMux
    port map (
            O => \N__1747\,
            I => \N__1736\
        );

    \I__366\ : Odrv12
    port map (
            O => \N__1744\,
            I => o_ram_rd_addr_c_9
        );

    \I__365\ : LocalMux
    port map (
            O => \N__1741\,
            I => o_ram_rd_addr_c_9
        );

    \I__364\ : LocalMux
    port map (
            O => \N__1736\,
            I => o_ram_rd_addr_c_9
        );

    \I__363\ : InMux
    port map (
            O => \N__1729\,
            I => un1_r_ram_rd_addr_cry_8
        );

    \I__362\ : IoInMux
    port map (
            O => \N__1726\,
            I => \N__1723\
        );

    \I__361\ : LocalMux
    port map (
            O => \N__1723\,
            I => \N__1720\
        );

    \I__360\ : IoSpan4Mux
    port map (
            O => \N__1720\,
            I => \N__1716\
        );

    \I__359\ : CascadeMux
    port map (
            O => \N__1719\,
            I => \N__1711\
        );

    \I__358\ : Span4Mux_s2_v
    port map (
            O => \N__1716\,
            I => \N__1708\
        );

    \I__357\ : InMux
    port map (
            O => \N__1715\,
            I => \N__1705\
        );

    \I__356\ : InMux
    port map (
            O => \N__1714\,
            I => \N__1702\
        );

    \I__355\ : InMux
    port map (
            O => \N__1711\,
            I => \N__1699\
        );

    \I__354\ : Odrv4
    port map (
            O => \N__1708\,
            I => o_ram_rd_addr_c_10
        );

    \I__353\ : LocalMux
    port map (
            O => \N__1705\,
            I => o_ram_rd_addr_c_10
        );

    \I__352\ : LocalMux
    port map (
            O => \N__1702\,
            I => o_ram_rd_addr_c_10
        );

    \I__351\ : LocalMux
    port map (
            O => \N__1699\,
            I => o_ram_rd_addr_c_10
        );

    \I__350\ : InMux
    port map (
            O => \N__1690\,
            I => un1_r_ram_rd_addr_cry_9
        );

    \I__349\ : InMux
    port map (
            O => \N__1687\,
            I => un1_r_ram_rd_addr_cry_10
        );

    \I__348\ : IoInMux
    port map (
            O => \N__1684\,
            I => \N__1681\
        );

    \I__347\ : LocalMux
    port map (
            O => \N__1681\,
            I => \N__1678\
        );

    \I__346\ : IoSpan4Mux
    port map (
            O => \N__1678\,
            I => \N__1675\
        );

    \I__345\ : Sp12to4
    port map (
            O => \N__1675\,
            I => \N__1669\
        );

    \I__344\ : InMux
    port map (
            O => \N__1674\,
            I => \N__1666\
        );

    \I__343\ : InMux
    port map (
            O => \N__1673\,
            I => \N__1663\
        );

    \I__342\ : InMux
    port map (
            O => \N__1672\,
            I => \N__1660\
        );

    \I__341\ : Odrv12
    port map (
            O => \N__1669\,
            I => o_ram_rd_addr_c_11
        );

    \I__340\ : LocalMux
    port map (
            O => \N__1666\,
            I => o_ram_rd_addr_c_11
        );

    \I__339\ : LocalMux
    port map (
            O => \N__1663\,
            I => o_ram_rd_addr_c_11
        );

    \I__338\ : LocalMux
    port map (
            O => \N__1660\,
            I => o_ram_rd_addr_c_11
        );

    \I__337\ : ClkMux
    port map (
            O => \N__1651\,
            I => \N__1636\
        );

    \I__336\ : ClkMux
    port map (
            O => \N__1650\,
            I => \N__1636\
        );

    \I__335\ : ClkMux
    port map (
            O => \N__1649\,
            I => \N__1636\
        );

    \I__334\ : ClkMux
    port map (
            O => \N__1648\,
            I => \N__1636\
        );

    \I__333\ : ClkMux
    port map (
            O => \N__1647\,
            I => \N__1636\
        );

    \I__332\ : GlobalMux
    port map (
            O => \N__1636\,
            I => \N__1633\
        );

    \I__331\ : gio2CtrlBuf
    port map (
            O => \N__1633\,
            I => i_clk_c_g
        );

    \I__330\ : SRMux
    port map (
            O => \N__1630\,
            I => \N__1626\
        );

    \I__329\ : SRMux
    port map (
            O => \N__1629\,
            I => \N__1623\
        );

    \I__328\ : LocalMux
    port map (
            O => \N__1626\,
            I => \r_state_RNIIB3C4Z0Z_1\
        );

    \I__327\ : LocalMux
    port map (
            O => \N__1623\,
            I => \r_state_RNIIB3C4Z0Z_1\
        );

    \I__326\ : CascadeMux
    port map (
            O => \N__1618\,
            I => \n_state_5_sqmuxa_0_a3_0_a2_0_cascade_\
        );

    \I__325\ : InMux
    port map (
            O => \N__1615\,
            I => \N__1612\
        );

    \I__324\ : LocalMux
    port map (
            O => \N__1612\,
            I => n_state_5_sqmuxa_0_a3_0_a2_9
        );

    \I__323\ : InMux
    port map (
            O => \N__1609\,
            I => \N__1606\
        );

    \I__322\ : LocalMux
    port map (
            O => \N__1606\,
            I => r_state_ns_i_i_a2_0_8_1
        );

    \I__321\ : CascadeMux
    port map (
            O => \N__1603\,
            I => \N__1597\
        );

    \I__320\ : InMux
    port map (
            O => \N__1602\,
            I => \N__1594\
        );

    \I__319\ : InMux
    port map (
            O => \N__1601\,
            I => \N__1589\
        );

    \I__318\ : InMux
    port map (
            O => \N__1600\,
            I => \N__1589\
        );

    \I__317\ : InMux
    port map (
            O => \N__1597\,
            I => \N__1586\
        );

    \I__316\ : LocalMux
    port map (
            O => \N__1594\,
            I => n_send_tx_byte_0_sqmuxa
        );

    \I__315\ : LocalMux
    port map (
            O => \N__1589\,
            I => n_send_tx_byte_0_sqmuxa
        );

    \I__314\ : LocalMux
    port map (
            O => \N__1586\,
            I => n_send_tx_byte_0_sqmuxa
        );

    \I__313\ : IoInMux
    port map (
            O => \N__1579\,
            I => \N__1576\
        );

    \I__312\ : LocalMux
    port map (
            O => \N__1576\,
            I => \N__1571\
        );

    \I__311\ : InMux
    port map (
            O => \N__1575\,
            I => \N__1568\
        );

    \I__310\ : InMux
    port map (
            O => \N__1574\,
            I => \N__1565\
        );

    \I__309\ : Odrv12
    port map (
            O => \N__1571\,
            I => o_ram_rd_addr_c_0
        );

    \I__308\ : LocalMux
    port map (
            O => \N__1568\,
            I => o_ram_rd_addr_c_0
        );

    \I__307\ : LocalMux
    port map (
            O => \N__1565\,
            I => o_ram_rd_addr_c_0
        );

    \I__306\ : IoInMux
    port map (
            O => \N__1558\,
            I => \N__1555\
        );

    \I__305\ : LocalMux
    port map (
            O => \N__1555\,
            I => \N__1552\
        );

    \I__304\ : Span4Mux_s0_v
    port map (
            O => \N__1552\,
            I => \N__1548\
        );

    \I__303\ : CascadeMux
    port map (
            O => \N__1551\,
            I => \N__1544\
        );

    \I__302\ : Span4Mux_v
    port map (
            O => \N__1548\,
            I => \N__1541\
        );

    \I__301\ : InMux
    port map (
            O => \N__1547\,
            I => \N__1538\
        );

    \I__300\ : InMux
    port map (
            O => \N__1544\,
            I => \N__1535\
        );

    \I__299\ : Odrv4
    port map (
            O => \N__1541\,
            I => o_ram_rd_addr_c_1
        );

    \I__298\ : LocalMux
    port map (
            O => \N__1538\,
            I => o_ram_rd_addr_c_1
        );

    \I__297\ : LocalMux
    port map (
            O => \N__1535\,
            I => o_ram_rd_addr_c_1
        );

    \I__296\ : InMux
    port map (
            O => \N__1528\,
            I => un1_r_ram_rd_addr_cry_0
        );

    \I__295\ : IoInMux
    port map (
            O => \N__1525\,
            I => \N__1522\
        );

    \I__294\ : LocalMux
    port map (
            O => \N__1522\,
            I => \N__1519\
        );

    \I__293\ : Span4Mux_s2_v
    port map (
            O => \N__1519\,
            I => \N__1516\
        );

    \I__292\ : Span4Mux_v
    port map (
            O => \N__1516\,
            I => \N__1511\
        );

    \I__291\ : InMux
    port map (
            O => \N__1515\,
            I => \N__1508\
        );

    \I__290\ : InMux
    port map (
            O => \N__1514\,
            I => \N__1505\
        );

    \I__289\ : Odrv4
    port map (
            O => \N__1511\,
            I => o_ram_rd_addr_c_2
        );

    \I__288\ : LocalMux
    port map (
            O => \N__1508\,
            I => o_ram_rd_addr_c_2
        );

    \I__287\ : LocalMux
    port map (
            O => \N__1505\,
            I => o_ram_rd_addr_c_2
        );

    \I__286\ : InMux
    port map (
            O => \N__1498\,
            I => un1_r_ram_rd_addr_cry_1
        );

    \I__285\ : IoInMux
    port map (
            O => \N__1495\,
            I => \N__1492\
        );

    \I__284\ : LocalMux
    port map (
            O => \N__1492\,
            I => \N__1489\
        );

    \I__283\ : Span4Mux_s2_v
    port map (
            O => \N__1489\,
            I => \N__1486\
        );

    \I__282\ : Span4Mux_v
    port map (
            O => \N__1486\,
            I => \N__1481\
        );

    \I__281\ : InMux
    port map (
            O => \N__1485\,
            I => \N__1478\
        );

    \I__280\ : InMux
    port map (
            O => \N__1484\,
            I => \N__1475\
        );

    \I__279\ : Odrv4
    port map (
            O => \N__1481\,
            I => o_ram_rd_addr_c_3
        );

    \I__278\ : LocalMux
    port map (
            O => \N__1478\,
            I => o_ram_rd_addr_c_3
        );

    \I__277\ : LocalMux
    port map (
            O => \N__1475\,
            I => o_ram_rd_addr_c_3
        );

    \I__276\ : InMux
    port map (
            O => \N__1468\,
            I => un1_r_ram_rd_addr_cry_2
        );

    \I__275\ : IoInMux
    port map (
            O => \N__1465\,
            I => \N__1462\
        );

    \I__274\ : LocalMux
    port map (
            O => \N__1462\,
            I => \N__1459\
        );

    \I__273\ : Span12Mux_s6_v
    port map (
            O => \N__1459\,
            I => \N__1454\
        );

    \I__272\ : InMux
    port map (
            O => \N__1458\,
            I => \N__1451\
        );

    \I__271\ : InMux
    port map (
            O => \N__1457\,
            I => \N__1448\
        );

    \I__270\ : Odrv12
    port map (
            O => \N__1454\,
            I => o_ram_rd_addr_c_4
        );

    \I__269\ : LocalMux
    port map (
            O => \N__1451\,
            I => o_ram_rd_addr_c_4
        );

    \I__268\ : LocalMux
    port map (
            O => \N__1448\,
            I => o_ram_rd_addr_c_4
        );

    \I__267\ : InMux
    port map (
            O => \N__1441\,
            I => un1_r_ram_rd_addr_cry_3
        );

    \I__266\ : IoInMux
    port map (
            O => \N__1438\,
            I => \N__1435\
        );

    \I__265\ : LocalMux
    port map (
            O => \N__1435\,
            I => \N__1431\
        );

    \I__264\ : CascadeMux
    port map (
            O => \N__1434\,
            I => \N__1428\
        );

    \I__263\ : Span4Mux_s3_v
    port map (
            O => \N__1431\,
            I => \N__1424\
        );

    \I__262\ : InMux
    port map (
            O => \N__1428\,
            I => \N__1421\
        );

    \I__261\ : InMux
    port map (
            O => \N__1427\,
            I => \N__1418\
        );

    \I__260\ : Span4Mux_h
    port map (
            O => \N__1424\,
            I => \N__1413\
        );

    \I__259\ : LocalMux
    port map (
            O => \N__1421\,
            I => \N__1413\
        );

    \I__258\ : LocalMux
    port map (
            O => \N__1418\,
            I => o_ram_rd_addr_c_5
        );

    \I__257\ : Odrv4
    port map (
            O => \N__1413\,
            I => o_ram_rd_addr_c_5
        );

    \I__256\ : InMux
    port map (
            O => \N__1408\,
            I => un1_r_ram_rd_addr_cry_4
        );

    \I__255\ : IoInMux
    port map (
            O => \N__1405\,
            I => \N__1402\
        );

    \I__254\ : LocalMux
    port map (
            O => \N__1402\,
            I => \N__1399\
        );

    \I__253\ : Span4Mux_s3_v
    port map (
            O => \N__1399\,
            I => \N__1396\
        );

    \I__252\ : Span4Mux_h
    port map (
            O => \N__1396\,
            I => \N__1391\
        );

    \I__251\ : InMux
    port map (
            O => \N__1395\,
            I => \N__1388\
        );

    \I__250\ : InMux
    port map (
            O => \N__1394\,
            I => \N__1385\
        );

    \I__249\ : Odrv4
    port map (
            O => \N__1391\,
            I => o_ram_rd_addr_c_6
        );

    \I__248\ : LocalMux
    port map (
            O => \N__1388\,
            I => o_ram_rd_addr_c_6
        );

    \I__247\ : LocalMux
    port map (
            O => \N__1385\,
            I => o_ram_rd_addr_c_6
        );

    \I__246\ : InMux
    port map (
            O => \N__1378\,
            I => un1_r_ram_rd_addr_cry_5
        );

    \I__245\ : InMux
    port map (
            O => \N__1375\,
            I => \N__1371\
        );

    \I__244\ : InMux
    port map (
            O => \N__1374\,
            I => \N__1368\
        );

    \I__243\ : LocalMux
    port map (
            O => \N__1371\,
            I => i_send_start_pulse_c
        );

    \I__242\ : LocalMux
    port map (
            O => \N__1368\,
            I => i_send_start_pulse_c
        );

    \I__241\ : InMux
    port map (
            O => \N__1363\,
            I => \N__1360\
        );

    \I__240\ : LocalMux
    port map (
            O => \N__1360\,
            I => r_state_ns_i_i_a2_0_6_1
        );

    \I__239\ : CascadeMux
    port map (
            O => \N__1357\,
            I => \N__1354\
        );

    \I__238\ : InMux
    port map (
            O => \N__1354\,
            I => \N__1348\
        );

    \I__237\ : InMux
    port map (
            O => \N__1353\,
            I => \N__1348\
        );

    \I__236\ : LocalMux
    port map (
            O => \N__1348\,
            I => r_state_ns_i_i_a2_0_7_1
        );

    \I__235\ : CascadeMux
    port map (
            O => \N__1345\,
            I => \r_state_ns_i_i_a2_0_6_1_cascade_\
        );

    \I__234\ : CascadeMux
    port map (
            O => \N__1342\,
            I => \r_ram_rd_addr_RNIDTLB3Z0Z_11_cascade_\
        );

    \I__233\ : InMux
    port map (
            O => \N__1339\,
            I => \N__1336\
        );

    \I__232\ : LocalMux
    port map (
            O => \N__1336\,
            I => r_ram_rd_addr_66_1
        );

    \I__231\ : CascadeMux
    port map (
            O => \N__1333\,
            I => \N__1329\
        );

    \I__230\ : InMux
    port map (
            O => \N__1332\,
            I => \N__1311\
        );

    \I__229\ : InMux
    port map (
            O => \N__1329\,
            I => \N__1311\
        );

    \I__228\ : InMux
    port map (
            O => \N__1328\,
            I => \N__1311\
        );

    \I__227\ : InMux
    port map (
            O => \N__1327\,
            I => \N__1311\
        );

    \I__226\ : InMux
    port map (
            O => \N__1326\,
            I => \N__1311\
        );

    \I__225\ : InMux
    port map (
            O => \N__1325\,
            I => \N__1311\
        );

    \I__224\ : InMux
    port map (
            O => \N__1324\,
            I => \N__1308\
        );

    \I__223\ : LocalMux
    port map (
            O => \N__1311\,
            I => \N__1303\
        );

    \I__222\ : LocalMux
    port map (
            O => \N__1308\,
            I => \N__1303\
        );

    \I__221\ : Span4Mux_v
    port map (
            O => \N__1303\,
            I => \N__1300\
        );

    \I__220\ : Span4Mux_v
    port map (
            O => \N__1300\,
            I => \N__1297\
        );

    \I__219\ : Odrv4
    port map (
            O => \N__1297\,
            I => i_tx_busy_c
        );

    \I__218\ : InMux
    port map (
            O => \N__1294\,
            I => \N__1285\
        );

    \I__217\ : InMux
    port map (
            O => \N__1293\,
            I => \N__1285\
        );

    \I__216\ : InMux
    port map (
            O => \N__1292\,
            I => \N__1278\
        );

    \I__215\ : InMux
    port map (
            O => \N__1291\,
            I => \N__1278\
        );

    \I__214\ : InMux
    port map (
            O => \N__1290\,
            I => \N__1278\
        );

    \I__213\ : LocalMux
    port map (
            O => \N__1285\,
            I => \N__1275\
        );

    \I__212\ : LocalMux
    port map (
            O => \N__1278\,
            I => \r_state_0_repZ0Z1\
        );

    \I__211\ : Odrv4
    port map (
            O => \N__1275\,
            I => \r_state_0_repZ0Z1\
        );

    \I__210\ : CascadeMux
    port map (
            O => \N__1270\,
            I => \r_state_RNO_0Z0Z_1_cascade_\
        );

    \I__209\ : InMux
    port map (
            O => \N__1267\,
            I => \N__1264\
        );

    \I__208\ : LocalMux
    port map (
            O => \N__1264\,
            I => \r_ram_rd_addr_RNIDTLB3Z0Z_11\
        );

    \I__207\ : InMux
    port map (
            O => \N__1261\,
            I => \N__1237\
        );

    \I__206\ : InMux
    port map (
            O => \N__1260\,
            I => \N__1237\
        );

    \I__205\ : InMux
    port map (
            O => \N__1259\,
            I => \N__1237\
        );

    \I__204\ : InMux
    port map (
            O => \N__1258\,
            I => \N__1237\
        );

    \I__203\ : InMux
    port map (
            O => \N__1257\,
            I => \N__1237\
        );

    \I__202\ : InMux
    port map (
            O => \N__1256\,
            I => \N__1237\
        );

    \I__201\ : InMux
    port map (
            O => \N__1255\,
            I => \N__1237\
        );

    \I__200\ : InMux
    port map (
            O => \N__1254\,
            I => \N__1237\
        );

    \I__199\ : LocalMux
    port map (
            O => \N__1237\,
            I => \N__1230\
        );

    \I__198\ : InMux
    port map (
            O => \N__1236\,
            I => \N__1225\
        );

    \I__197\ : InMux
    port map (
            O => \N__1235\,
            I => \N__1225\
        );

    \I__196\ : InMux
    port map (
            O => \N__1234\,
            I => \N__1220\
        );

    \I__195\ : InMux
    port map (
            O => \N__1233\,
            I => \N__1220\
        );

    \I__194\ : Odrv4
    port map (
            O => \N__1230\,
            I => \r_stateZ0Z_1\
        );

    \I__193\ : LocalMux
    port map (
            O => \N__1225\,
            I => \r_stateZ0Z_1\
        );

    \I__192\ : LocalMux
    port map (
            O => \N__1220\,
            I => \r_stateZ0Z_1\
        );

    \I__191\ : SRMux
    port map (
            O => \N__1213\,
            I => \N__1209\
        );

    \I__190\ : CascadeMux
    port map (
            O => \N__1212\,
            I => \N__1204\
        );

    \I__189\ : LocalMux
    port map (
            O => \N__1209\,
            I => \N__1197\
        );

    \I__188\ : InMux
    port map (
            O => \N__1208\,
            I => \N__1186\
        );

    \I__187\ : InMux
    port map (
            O => \N__1207\,
            I => \N__1186\
        );

    \I__186\ : InMux
    port map (
            O => \N__1204\,
            I => \N__1186\
        );

    \I__185\ : InMux
    port map (
            O => \N__1203\,
            I => \N__1186\
        );

    \I__184\ : InMux
    port map (
            O => \N__1202\,
            I => \N__1186\
        );

    \I__183\ : InMux
    port map (
            O => \N__1201\,
            I => \N__1181\
        );

    \I__182\ : InMux
    port map (
            O => \N__1200\,
            I => \N__1181\
        );

    \I__181\ : Span4Mux_h
    port map (
            O => \N__1197\,
            I => \N__1174\
        );

    \I__180\ : LocalMux
    port map (
            O => \N__1186\,
            I => \N__1174\
        );

    \I__179\ : LocalMux
    port map (
            O => \N__1181\,
            I => \N__1174\
        );

    \I__178\ : Span4Mux_v
    port map (
            O => \N__1174\,
            I => \N__1170\
        );

    \I__177\ : InMux
    port map (
            O => \N__1173\,
            I => \N__1167\
        );

    \I__176\ : Odrv4
    port map (
            O => \N__1170\,
            I => i_rst_c
        );

    \I__175\ : LocalMux
    port map (
            O => \N__1167\,
            I => i_rst_c
        );

    \I__174\ : IoInMux
    port map (
            O => \N__1162\,
            I => \N__1159\
        );

    \I__173\ : LocalMux
    port map (
            O => \N__1159\,
            I => \N__1156\
        );

    \I__172\ : Span12Mux_s0_h
    port map (
            O => \N__1156\,
            I => \N__1153\
        );

    \I__171\ : Odrv12
    port map (
            O => \N__1153\,
            I => o_send_tx_byte_c_1
        );

    \I__170\ : InMux
    port map (
            O => \N__1150\,
            I => \N__1147\
        );

    \I__169\ : LocalMux
    port map (
            O => \N__1147\,
            I => \N__1144\
        );

    \I__168\ : Span4Mux_v
    port map (
            O => \N__1144\,
            I => \N__1141\
        );

    \I__167\ : Span4Mux_v
    port map (
            O => \N__1141\,
            I => \N__1138\
        );

    \I__166\ : Odrv4
    port map (
            O => \N__1138\,
            I => i_ram_rd_data_c_4
        );

    \I__165\ : IoInMux
    port map (
            O => \N__1135\,
            I => \N__1132\
        );

    \I__164\ : LocalMux
    port map (
            O => \N__1132\,
            I => \N__1129\
        );

    \I__163\ : IoSpan4Mux
    port map (
            O => \N__1129\,
            I => \N__1126\
        );

    \I__162\ : Odrv4
    port map (
            O => \N__1126\,
            I => o_send_tx_byte_c_4
        );

    \I__161\ : CEMux
    port map (
            O => \N__1123\,
            I => \N__1120\
        );

    \I__160\ : LocalMux
    port map (
            O => \N__1120\,
            I => \N__1117\
        );

    \I__159\ : Span4Mux_v
    port map (
            O => \N__1117\,
            I => \N__1114\
        );

    \I__158\ : Odrv4
    port map (
            O => \N__1114\,
            I => \N_13_i_0\
        );

    \I__157\ : IoInMux
    port map (
            O => \N__1111\,
            I => \N__1108\
        );

    \I__156\ : LocalMux
    port map (
            O => \N__1108\,
            I => o_send_tx_start_pulse_c
        );

    \I__155\ : CascadeMux
    port map (
            O => \N__1105\,
            I => \N_18_cascade_\
        );

    \I__154\ : InMux
    port map (
            O => \N__1102\,
            I => \N__1088\
        );

    \I__153\ : InMux
    port map (
            O => \N__1101\,
            I => \N__1088\
        );

    \I__152\ : InMux
    port map (
            O => \N__1100\,
            I => \N__1079\
        );

    \I__151\ : InMux
    port map (
            O => \N__1099\,
            I => \N__1079\
        );

    \I__150\ : InMux
    port map (
            O => \N__1098\,
            I => \N__1079\
        );

    \I__149\ : InMux
    port map (
            O => \N__1097\,
            I => \N__1079\
        );

    \I__148\ : InMux
    port map (
            O => \N__1096\,
            I => \N__1070\
        );

    \I__147\ : InMux
    port map (
            O => \N__1095\,
            I => \N__1070\
        );

    \I__146\ : InMux
    port map (
            O => \N__1094\,
            I => \N__1070\
        );

    \I__145\ : InMux
    port map (
            O => \N__1093\,
            I => \N__1070\
        );

    \I__144\ : LocalMux
    port map (
            O => \N__1088\,
            I => \r_stateZ0Z_0\
        );

    \I__143\ : LocalMux
    port map (
            O => \N__1079\,
            I => \r_stateZ0Z_0\
        );

    \I__142\ : LocalMux
    port map (
            O => \N__1070\,
            I => \r_stateZ0Z_0\
        );

    \I__141\ : InMux
    port map (
            O => \N__1063\,
            I => \N__1057\
        );

    \I__140\ : InMux
    port map (
            O => \N__1062\,
            I => \N__1057\
        );

    \I__139\ : LocalMux
    port map (
            O => \N__1057\,
            I => \N_18\
        );

    \I__138\ : InMux
    port map (
            O => \N__1054\,
            I => \N__1048\
        );

    \I__137\ : InMux
    port map (
            O => \N__1053\,
            I => \N__1048\
        );

    \I__136\ : LocalMux
    port map (
            O => \N__1048\,
            I => \r_state_fastZ0Z_0\
        );

    \I__135\ : IoInMux
    port map (
            O => \N__1045\,
            I => \N__1042\
        );

    \I__134\ : LocalMux
    port map (
            O => \N__1042\,
            I => o_send_done_pulse_c
        );

    \I__133\ : InMux
    port map (
            O => \N__1039\,
            I => \N__1036\
        );

    \I__132\ : LocalMux
    port map (
            O => \N__1036\,
            I => \N__1033\
        );

    \I__131\ : Span4Mux_v
    port map (
            O => \N__1033\,
            I => \N__1030\
        );

    \I__130\ : Sp12to4
    port map (
            O => \N__1030\,
            I => \N__1027\
        );

    \I__129\ : Span12Mux_s9_h
    port map (
            O => \N__1027\,
            I => \N__1024\
        );

    \I__128\ : Odrv12
    port map (
            O => \N__1024\,
            I => i_ram_rd_data_c_5
        );

    \I__127\ : IoInMux
    port map (
            O => \N__1021\,
            I => \N__1018\
        );

    \I__126\ : LocalMux
    port map (
            O => \N__1018\,
            I => \N__1015\
        );

    \I__125\ : Span4Mux_s0_h
    port map (
            O => \N__1015\,
            I => \N__1012\
        );

    \I__124\ : Odrv4
    port map (
            O => \N__1012\,
            I => o_send_tx_byte_c_5
        );

    \I__123\ : InMux
    port map (
            O => \N__1009\,
            I => \N__1006\
        );

    \I__122\ : LocalMux
    port map (
            O => \N__1006\,
            I => \N__1003\
        );

    \I__121\ : Span4Mux_v
    port map (
            O => \N__1003\,
            I => \N__1000\
        );

    \I__120\ : Span4Mux_v
    port map (
            O => \N__1000\,
            I => \N__997\
        );

    \I__119\ : Odrv4
    port map (
            O => \N__997\,
            I => i_ram_rd_data_c_2
        );

    \I__118\ : IoInMux
    port map (
            O => \N__994\,
            I => \N__991\
        );

    \I__117\ : LocalMux
    port map (
            O => \N__991\,
            I => \N__988\
        );

    \I__116\ : Span4Mux_s0_h
    port map (
            O => \N__988\,
            I => \N__985\
        );

    \I__115\ : Odrv4
    port map (
            O => \N__985\,
            I => o_send_tx_byte_c_2
        );

    \I__114\ : InMux
    port map (
            O => \N__982\,
            I => \N__979\
        );

    \I__113\ : LocalMux
    port map (
            O => \N__979\,
            I => \N__976\
        );

    \I__112\ : Span4Mux_v
    port map (
            O => \N__976\,
            I => \N__973\
        );

    \I__111\ : Sp12to4
    port map (
            O => \N__973\,
            I => \N__970\
        );

    \I__110\ : Span12Mux_s8_h
    port map (
            O => \N__970\,
            I => \N__967\
        );

    \I__109\ : Odrv12
    port map (
            O => \N__967\,
            I => i_ram_rd_data_c_7
        );

    \I__108\ : IoInMux
    port map (
            O => \N__964\,
            I => \N__961\
        );

    \I__107\ : LocalMux
    port map (
            O => \N__961\,
            I => o_send_tx_byte_c_7
        );

    \I__106\ : InMux
    port map (
            O => \N__958\,
            I => \N__955\
        );

    \I__105\ : LocalMux
    port map (
            O => \N__955\,
            I => \N__952\
        );

    \I__104\ : Span4Mux_v
    port map (
            O => \N__952\,
            I => \N__949\
        );

    \I__103\ : Span4Mux_v
    port map (
            O => \N__949\,
            I => \N__946\
        );

    \I__102\ : Odrv4
    port map (
            O => \N__946\,
            I => i_ram_rd_data_c_3
        );

    \I__101\ : IoInMux
    port map (
            O => \N__943\,
            I => \N__940\
        );

    \I__100\ : LocalMux
    port map (
            O => \N__940\,
            I => \N__937\
        );

    \I__99\ : Span4Mux_s0_h
    port map (
            O => \N__937\,
            I => \N__934\
        );

    \I__98\ : Odrv4
    port map (
            O => \N__934\,
            I => o_send_tx_byte_c_3
        );

    \I__97\ : InMux
    port map (
            O => \N__931\,
            I => \N__928\
        );

    \I__96\ : LocalMux
    port map (
            O => \N__928\,
            I => \N__925\
        );

    \I__95\ : Span4Mux_v
    port map (
            O => \N__925\,
            I => \N__922\
        );

    \I__94\ : Sp12to4
    port map (
            O => \N__922\,
            I => \N__919\
        );

    \I__93\ : Span12Mux_s9_h
    port map (
            O => \N__919\,
            I => \N__916\
        );

    \I__92\ : Odrv12
    port map (
            O => \N__916\,
            I => i_ram_rd_data_c_6
        );

    \I__91\ : IoInMux
    port map (
            O => \N__913\,
            I => \N__910\
        );

    \I__90\ : LocalMux
    port map (
            O => \N__910\,
            I => o_send_tx_byte_c_6
        );

    \I__89\ : InMux
    port map (
            O => \N__907\,
            I => \N__904\
        );

    \I__88\ : LocalMux
    port map (
            O => \N__904\,
            I => \N__901\
        );

    \I__87\ : Span4Mux_v
    port map (
            O => \N__901\,
            I => \N__898\
        );

    \I__86\ : Span4Mux_v
    port map (
            O => \N__898\,
            I => \N__895\
        );

    \I__85\ : Odrv4
    port map (
            O => \N__895\,
            I => i_ram_rd_data_c_0
        );

    \I__84\ : IoInMux
    port map (
            O => \N__892\,
            I => \N__889\
        );

    \I__83\ : LocalMux
    port map (
            O => \N__889\,
            I => \N__886\
        );

    \I__82\ : IoSpan4Mux
    port map (
            O => \N__886\,
            I => \N__883\
        );

    \I__81\ : IoSpan4Mux
    port map (
            O => \N__883\,
            I => \N__880\
        );

    \I__80\ : Odrv4
    port map (
            O => \N__880\,
            I => o_send_tx_byte_c_0
        );

    \I__79\ : InMux
    port map (
            O => \N__877\,
            I => \N__874\
        );

    \I__78\ : LocalMux
    port map (
            O => \N__874\,
            I => \N__871\
        );

    \I__77\ : Odrv12
    port map (
            O => \N__871\,
            I => i_ram_rd_data_c_1
        );

    \IN_MUX_bfv_2_10_0_\ : ICE_CARRY_IN_MUX
    generic map (
            C_INIT => "00"
        )
    port map (
            carryinitin => '0',
            carryinitout => \bfn_2_10_0_\
        );

    \IN_MUX_bfv_2_11_0_\ : ICE_CARRY_IN_MUX
    generic map (
            C_INIT => "10"
        )
    port map (
            carryinitin => un1_r_ram_rd_addr_cry_7,
            carryinitout => \bfn_2_11_0_\
        );

    \GND\ : GND
    port map (
            Y => \GNDG0\
        );

    \VCC\ : VCC
    port map (
            Y => \VCCG0\
        );

    \GND_Inst\ : GND
    port map (
            Y => \_gnd_net_\
        );

    \r_send_tx_byte_esr_5_LC_1_8_0\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1000100011001100"
        )
    port map (
            in0 => \N__1255\,
            in1 => \N__1039\,
            in2 => \_gnd_net_\,
            in3 => \N__1098\,
            lcout => o_send_tx_byte_c_5,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_2_LC_1_8_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1010101000100010"
        )
    port map (
            in0 => \N__1009\,
            in1 => \N__1094\,
            in2 => \_gnd_net_\,
            in3 => \N__1259\,
            lcout => o_send_tx_byte_c_2,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_7_LC_1_8_2\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1101110111001100"
        )
    port map (
            in0 => \N__1257\,
            in1 => \N__982\,
            in2 => \_gnd_net_\,
            in3 => \N__1100\,
            lcout => o_send_tx_byte_c_7,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_3_LC_1_8_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1010101011101110"
        )
    port map (
            in0 => \N__958\,
            in1 => \N__1095\,
            in2 => \_gnd_net_\,
            in3 => \N__1260\,
            lcout => o_send_tx_byte_c_3,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_6_LC_1_8_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1000100011001100"
        )
    port map (
            in0 => \N__1256\,
            in1 => \N__931\,
            in2 => \_gnd_net_\,
            in3 => \N__1099\,
            lcout => o_send_tx_byte_c_6,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_0_LC_1_8_5\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1010101011101110"
        )
    port map (
            in0 => \N__907\,
            in1 => \N__1093\,
            in2 => \_gnd_net_\,
            in3 => \N__1258\,
            lcout => o_send_tx_byte_c_0,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_1_LC_1_8_6\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1000100011001100"
        )
    port map (
            in0 => \N__1254\,
            in1 => \N__877\,
            in2 => \_gnd_net_\,
            in3 => \N__1097\,
            lcout => o_send_tx_byte_c_1,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_send_tx_byte_esr_4_LC_1_8_7\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1010101011101110"
        )
    port map (
            in0 => \N__1150\,
            in1 => \N__1096\,
            in2 => \_gnd_net_\,
            in3 => \N__1261\,
            lcout => o_send_tx_byte_c_4,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1649\,
            ce => \N__1123\,
            sr => \N__1213\
        );

    \r_state_0_rep1_RNIPEUL_LC_1_9_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1101110111001100"
        )
    port map (
            in0 => \N__1328\,
            in1 => \N__1207\,
            in2 => \_gnd_net_\,
            in3 => \N__1291\,
            lcout => \N_13_i_0\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_send_tx_start_pulse_LC_1_9_2\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "0001000100000000"
        )
    port map (
            in0 => \N__1202\,
            in1 => \N__1325\,
            in2 => \_gnd_net_\,
            in3 => \N__1101\,
            lcout => o_send_tx_start_pulse_c,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1647\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_fast_RNITHTI_0_LC_1_9_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0100010000000000"
        )
    port map (
            in0 => \N__1332\,
            in1 => \N__1233\,
            in2 => \_gnd_net_\,
            in3 => \N__1053\,
            lcout => n_send_tx_byte_0_sqmuxa,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_0_rep1_LC_1_9_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "0000000000001101"
        )
    port map (
            in0 => \N__1292\,
            in1 => \N__1327\,
            in2 => \N__1212\,
            in3 => \N__1062\,
            lcout => \r_state_0_repZ0Z1\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1647\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \i_send_start_pulse_ibuf_RNIVVOJ_LC_1_9_5\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0000000000010001"
        )
    port map (
            in0 => \N__1375\,
            in1 => \N__1290\,
            in2 => \_gnd_net_\,
            in3 => \N__1234\,
            lcout => \N_18\,
            ltout => \N_18_cascade_\,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_0_LC_1_9_6\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "0000010000000101"
        )
    port map (
            in0 => \N__1203\,
            in1 => \N__1326\,
            in2 => \N__1105\,
            in3 => \N__1102\,
            lcout => \r_stateZ0Z_0\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1647\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_fast_0_LC_1_9_7\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "0001000000010001"
        )
    port map (
            in0 => \N__1063\,
            in1 => \N__1208\,
            in2 => \N__1333\,
            in3 => \N__1054\,
            lcout => \r_state_fastZ0Z_0\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1647\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_send_done_pulse_LC_1_10_0\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1000000000000000"
        )
    port map (
            in0 => \N__1363\,
            in1 => \N__1601\,
            in2 => \N__1357\,
            in3 => \N__1615\,
            lcout => o_send_done_pulse_c,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1648\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_ram_rd_addr_RNI6R911_0_LC_1_10_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1000000000000000"
        )
    port map (
            in0 => \N__1484\,
            in1 => \N__1574\,
            in2 => \N__1551\,
            in3 => \N__1514\,
            lcout => r_state_ns_i_i_a2_0_7_1,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \i_send_start_pulse_ibuf_RNI4VFH_LC_1_10_2\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0000000010101010"
        )
    port map (
            in0 => \N__1374\,
            in1 => \_gnd_net_\,
            in2 => \_gnd_net_\,
            in3 => \N__1293\,
            lcout => r_ram_rd_addr_66_1,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_ram_rd_addr_RNIMBA11_4_LC_1_10_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1000000000000000"
        )
    port map (
            in0 => \N__1394\,
            in1 => \N__1811\,
            in2 => \N__1434\,
            in3 => \N__1457\,
            lcout => r_state_ns_i_i_a2_0_6_1,
            ltout => \r_state_ns_i_i_a2_0_6_1_cascade_\,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_ram_rd_addr_RNIDTLB3_11_LC_1_10_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1000000000000000"
        )
    port map (
            in0 => \N__1353\,
            in1 => \N__1600\,
            in2 => \N__1345\,
            in3 => \N__1609\,
            lcout => \r_ram_rd_addr_RNIDTLB3Z0Z_11\,
            ltout => \r_ram_rd_addr_RNIDTLB3Z0Z_11_cascade_\,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_RNIIB3C4_1_LC_1_10_5\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1111110111111100"
        )
    port map (
            in0 => \N__1235\,
            in1 => \N__1201\,
            in2 => \N__1342\,
            in3 => \N__1339\,
            lcout => \r_state_RNIIB3C4Z0Z_1\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_RNO_0_1_LC_1_10_6\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0000000010111011"
        )
    port map (
            in0 => \N__1324\,
            in1 => \N__1294\,
            in2 => \_gnd_net_\,
            in3 => \N__1236\,
            lcout => OPEN,
            ltout => \r_state_RNO_0Z0Z_1_cascade_\,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_state_1_LC_1_10_7\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "0000000000000011"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1200\,
            in2 => \N__1270\,
            in3 => \N__1267\,
            lcout => \r_stateZ0Z_1\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1648\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_send_done_pulse_RNO_1_LC_1_11_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0101010100000000"
        )
    port map (
            in0 => \N__1173\,
            in1 => \_gnd_net_\,
            in2 => \_gnd_net_\,
            in3 => \N__1778\,
            lcout => OPEN,
            ltout => \n_state_5_sqmuxa_0_a3_0_a2_0_cascade_\,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_send_done_pulse_RNO_0_LC_1_11_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1000000000000000"
        )
    port map (
            in0 => \N__1714\,
            in1 => \N__1748\,
            in2 => \N__1618\,
            in3 => \N__1673\,
            lcout => n_state_5_sqmuxa_0_a3_0_a2_9,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_ram_rd_addr_RNIK44M_11_LC_1_11_7\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1000000000000000"
        )
    port map (
            in0 => \N__1747\,
            in1 => \N__1777\,
            in2 => \N__1719\,
            in3 => \N__1672\,
            lcout => r_state_ns_i_i_a2_0_8_1,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_ram_rd_addr_0_LC_2_10_0\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1575\,
            in2 => \N__1603\,
            in3 => \N__1602\,
            lcout => o_ram_rd_addr_c_0,
            ltout => OPEN,
            carryin => \bfn_2_10_0_\,
            carryout => un1_r_ram_rd_addr_cry_0,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_1_LC_2_10_1\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1547\,
            in2 => \_gnd_net_\,
            in3 => \N__1528\,
            lcout => o_ram_rd_addr_c_1,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_0,
            carryout => un1_r_ram_rd_addr_cry_1,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_2_LC_2_10_2\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1515\,
            in2 => \_gnd_net_\,
            in3 => \N__1498\,
            lcout => o_ram_rd_addr_c_2,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_1,
            carryout => un1_r_ram_rd_addr_cry_2,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_3_LC_2_10_3\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1485\,
            in2 => \_gnd_net_\,
            in3 => \N__1468\,
            lcout => o_ram_rd_addr_c_3,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_2,
            carryout => un1_r_ram_rd_addr_cry_3,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_4_LC_2_10_4\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1458\,
            in2 => \_gnd_net_\,
            in3 => \N__1441\,
            lcout => o_ram_rd_addr_c_4,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_3,
            carryout => un1_r_ram_rd_addr_cry_4,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_5_LC_2_10_5\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1427\,
            in2 => \_gnd_net_\,
            in3 => \N__1408\,
            lcout => o_ram_rd_addr_c_5,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_4,
            carryout => un1_r_ram_rd_addr_cry_5,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_6_LC_2_10_6\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1395\,
            in2 => \_gnd_net_\,
            in3 => \N__1378\,
            lcout => o_ram_rd_addr_c_6,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_5,
            carryout => un1_r_ram_rd_addr_cry_6,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_7_LC_2_10_7\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1812\,
            in2 => \_gnd_net_\,
            in3 => \N__1795\,
            lcout => o_ram_rd_addr_c_7,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_6,
            carryout => un1_r_ram_rd_addr_cry_7,
            clk => \N__1650\,
            ce => 'H',
            sr => \N__1629\
        );

    \r_ram_rd_addr_8_LC_2_11_0\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1779\,
            in2 => \_gnd_net_\,
            in3 => \N__1759\,
            lcout => o_ram_rd_addr_c_8,
            ltout => OPEN,
            carryin => \bfn_2_11_0_\,
            carryout => un1_r_ram_rd_addr_cry_8,
            clk => \N__1651\,
            ce => 'H',
            sr => \N__1630\
        );

    \r_ram_rd_addr_9_LC_2_11_1\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1749\,
            in2 => \_gnd_net_\,
            in3 => \N__1729\,
            lcout => o_ram_rd_addr_c_9,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_8,
            carryout => un1_r_ram_rd_addr_cry_9,
            clk => \N__1651\,
            ce => 'H',
            sr => \N__1630\
        );

    \r_ram_rd_addr_10_LC_2_11_2\ : LogicCell40
    generic map (
            C_ON => '1',
            SEQ_MODE => "1000",
            LUT_INIT => "1001100101100110"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1715\,
            in2 => \_gnd_net_\,
            in3 => \N__1690\,
            lcout => o_ram_rd_addr_c_10,
            ltout => OPEN,
            carryin => un1_r_ram_rd_addr_cry_9,
            carryout => un1_r_ram_rd_addr_cry_10,
            clk => \N__1651\,
            ce => 'H',
            sr => \N__1630\
        );

    \r_ram_rd_addr_11_LC_2_11_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "0011001111001100"
        )
    port map (
            in0 => \_gnd_net_\,
            in1 => \N__1674\,
            in2 => \_gnd_net_\,
            in3 => \N__1687\,
            lcout => o_ram_rd_addr_c_11,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__1651\,
            ce => 'H',
            sr => \N__1630\
        );
end \INTERFACE\;
