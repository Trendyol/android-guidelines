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


## string
> **\<where>\_\<description>** (snake_case)

| where          | description     | value                            | sample                          |
| :------------- | :-------------- | :------------------------------- | :------------------------------ |
| product detail | product info    | Ürün Bilgileri                   | product_detail_product_info     |
| everywhere     | no result       | Sonuç Bulunamadı                 | common_no_result                |
| edit address   | success message | Adresiniz başarıyla güncellendi. | edit_address_success            |
| filter         | title           | Filtreleme                       | filter_title                    |
| filter         | filter button   | Ürünleri Listele (%d)            | filter_button_text              |


## /drawable
> **\<what>\_\<where>\_\<description>\_\<variant>** (snake_case)

| what           | where           | description       | variant (optional)    | sample                                    |
| :------------- | :-------------- | :---------------- | :-------------------- | :---------------------------------------- |
| icon           | catogory menu   | no result         | -                     | ic_category_menu_no_result.xml            |
| icon           | everywhere      | info              | -                     | ic_common_info.xml                        |
| shape          | everywhere      | button background | orange                | shape_common_button_background_orange.xml |
| icon           | everywhere      | search            | black 24dp            | ic_common_search_black_24dp.xml           |
| selector       | search result   | campaign tag      | -                     | selector_search_result_campaign.xml       |


## dimen
> **\<what>\_\<where>\_\<size>** (snake_case)

| what           | where (optional)     | size (optional)         | sample                      |
| :------------- | :------------------- | :---------------------- | :-------------------------- |
| padding        | -                    | 16dp                    | padding_16dp                |
| margin         | -                    | 8dp                     | margin_8dp                  |
| text size      | -                    | medium                  | text_size_medium            |
| size           | catogory menu image  | -                       | size_category_menu_image    |
| height         | similar product item | -                       | height_similar_product_item |
| radius         | common card view     | -                       | radius_card_view            |
