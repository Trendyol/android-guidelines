# Resource Naming Guideline

## /layout
> **\<what>\_\<where>** (snake_case)

| what          | where                                               | sample                        |
| :------------ | :-------------------------------------------------- | :---------------------------- |
| activity      | Content View of **Activity**                        | activity_splash.xml           |
| fragment      | View of **Fragment**                                | fragment_product_detail.xml   |
| dialog        | View of **Dialog**                                  | dialog_new_year_promotion.xml |
| item          | Layout of **RecyclerView/ListView/GridView**'s item | item_order_summary.xml        |
| view          | Layout of **Custom Views**                          | view_counter.xml              |
| layout        | **xml included** layouts                            | layout_no_result.xml          |


## id
> **\<what>\_\<description>** (camelCase)

| what               | description                   | sample                                    |
| :----------------- | :---------------------------- | :---------------------------------------- |
| textView           | welcome message               | textViewWelcome                           |
| button             | add to favorite               | buttonAddFavorite                         |
| recyclerView       | size option list              | recyclerViewSelectSize                    |
| relativeLayout     | main container of dialog      | relativeLayoutContainer                   |
| layout             | included layout for no result | layoutNoResult                            |
| imageView          | user profile image            | imageViewAccountProfile                   |
| swipeRefreshLayout | refresh product listing       | swipeRefreshLayoutProductList             |
