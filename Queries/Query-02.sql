-- Найти продаже, цены без скидки в которых отличаются от цены на товар.
SELECT s.ID_SALE, c.NAME, w.NAME, sstr.PRICE, w.PRICE
FROM T_SALE s
JOIN T_SALE_STR sstr ON s.ID_SALE = sstr.ID_SALE
JOIN T_WARE w ON sstr.ID_WARE = w.ID_WARE
JOIN T_CLIENT c ON s.ID_CLIENT = c.ID_CLIENT
WHERE w.PRICE != sstr.PRICE;