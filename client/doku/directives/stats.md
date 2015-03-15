# Stats Directive
module app.support

Shows the total amount of funded bge's a progress bar with the current funding state.

## Params
- link (optional) boolean --default=false "Shows a link to the support page"

## Translation Keys ("key" | "parameter")


#### Used from global
- OF
 
#### Declared
- STATS_SUPPORT_BUTTON
- STATS_HEADING | count
- STATS_INTRO | amount

### Usage

```html
<mge-stats></mge-stats>
<mge-stats link="true"></mge-stats> 
```