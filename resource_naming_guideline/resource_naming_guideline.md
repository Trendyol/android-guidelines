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
> **\<what>\_\<where>\_\<description>** (camelCase and snake_case)

| what           | where                     | description                   | sample                                    |
| :------------- | :------------------------ | :---------------------------- | :---------------------------------------- |
| textView       | in SplashActivity         | welcome message               | textView_splash_welcome                   |
| button         | in ProductDetailFragment  | add to favorite               | button_productDetail_addFavorite          |
| recyclerView   | in SelectSizeDialog       | size option list              | recyclerView_selectSize                   |
| relativeLayout | in NewYearPromotionDialog | main container of dialog      | relativeLayout_newYearPromotion_container |
| layout         | in SearchResult           | included layout for no result | layout_searchResult_noResult              |
| imageView      | in AccountActivity        | user profile image            | imageView_account_profile                 |
| swipeRefreshLayout | in ProductListLayout  | refresh product listing      | swipeRefreshLayout_productList            |
