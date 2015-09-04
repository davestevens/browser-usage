# Browser Usage

Interactive current Browser Usage data for investigating the browsers we should be supporting.

## Data

Data is extracted from [Can I use](http://caniuse.com/usage-table)

To fetch the latest data run:
```shell
npm run fetch-data
```

This will update the file `src/coffee/data.json` with the most up-to-date browser statistics.

## TODO

- [ ] Filter data (on click/highlight)
- [ ] Hide some of the versions (< 1% ?)
- [ ] Styling

## Notes

Uses [Static Site Skeleton](https://github.com/davestevens/static-site-skeleton) for structure and builing.
