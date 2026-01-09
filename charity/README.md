
# Charity data

To get links to the charity data in a structured way,
go to https://register-of-charities.charitycommission.gov.uk/en/register/full-register-download
and run this in the console:
```js
links = $$('td:nth-child(3) a[id]')
links.map(l=>({id:l.id, href:l.href}))
```

Then write SQL statements to create tables based on those links, using DuckDBs `httpfs` and `zipfs` extensions.

## Loading database

To load a duckdb database with charity data, run

```bash
duckdb -f loadCharity.sql charity.ddb
```