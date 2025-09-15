UPDATE household_details
SET 
    -- did not work.
    acorn_group_previous    = acorn_group,
    acorn_group             = CASE acorn
                                WHEN 'ACORN-A' THEN 'Luxury Lifestyles'
                                WHEN 'ACORN-B' THEN 'Luxury Lifestyles'
                                WHEN 'ACORN-C' THEN 'Luxury Lifestyles'
                                WHEN 'ACORN-D' THEN 'Established Affluence'
                                WHEN 'ACORN-E' THEN 'Established Affluence'
                                WHEN 'ACORN-F' THEN 'Thriving Neighbourhoods'
                                WHEN 'ACORN-G' THEN 'Thriving Neighbourhoods'
                                WHEN 'ACORN-H' THEN 'Thriving Neighbourhoods'
                                WHEN 'ACORN-I' THEN 'Thriving Neighbourhoods'
                                WHEN 'ACORN-J' THEN 'Thriving Neighbourhoods'
                                WHEN 'ACORN-K' THEN 'Steadfast Communities'
                                WHEN 'ACORN-L' THEN 'Steadfast Communities'
                                WHEN 'ACORN-M' THEN 'Steadfast Communities'
                                WHEN 'ACORN-N' THEN 'Steadfast Communities'
                                WHEN 'ACORN-O' THEN 'Steadfast Communities'
                                WHEN 'ACORN-P' THEN 'Stretched Society'
                                WHEN 'ACORN-Q' THEN 'Stretched Society'
                                WHEN 'ACORN-R' THEN 'Stretched Society'
                                WHEN 'ACORN-S' THEN 'Stretched Society'
                                WHEN 'ACORN-T' THEN 'Low Income Living'
                                WHEN 'ACORN-U' THEN 'Low Income Living'
                                WHEN 'ACORN-V' THEN 'Not Private Households'
                                ELSE acorn_group 
                              END,
    acorn_group_changeddate = CURRENT_TIMESTAMP
WHERE acorn IN ('ACORN-A','ACORN-B','ACORN-C','ACORN-D','ACORN-E','ACORN-F','ACORN-G','ACORN-H','ACORN-I','ACORN-J','ACORN-K',
                'ACORN-L','ACORN-M','ACORN-N','ACORN-O','ACORN-P','ACORN-Q','ACORN-R','ACORN-S','ACORN-T','ACORN-U','ACORN-V');
