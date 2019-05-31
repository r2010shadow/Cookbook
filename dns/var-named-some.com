$TTL 86400
@	IN SOA  some.com. root.some.com. (
					0	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
@	IN NS	some.com.
@	IN A	10.10.3.100
*       IN A 	10.10.3.100
mail	IN A 	10.20.116.120
