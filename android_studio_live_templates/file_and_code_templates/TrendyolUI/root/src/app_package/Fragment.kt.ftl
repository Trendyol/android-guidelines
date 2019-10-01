package ${packageName}
<#assign viewModelClassName= className + 'ViewModel'>
<#assign viewModelFieldName= viewModelClassName?substring(0,1)?lower_case + viewModelClassName?substring(1)>
<#assign splitLayoutName= layout?split('_')>
<#assign bindingClass=''>
<#list splitLayoutName as stra>
  <#assign modified = stra?substring(0,1)?upper_case + stra?substring(1)>
  <#assign bindingClass = bindingClass + modified>
</#list>
<#assign bindingClass= bindingClass + 'Binding'>
<#assign pageViewStateClassName = className + 'PageViewState'>
<#assign pageViewStateFieldName = pageViewStateClassName?substring(0,1)?lower_case + pageViewStateClassName?substring(1) + 'LiveData'>
<#assign pageViewStatePublicMethodName = 'get' + pageViewStateClassName + 'LiveData'>
<#assign fragmentName = className + 'Fragment'>

import android.os.Bundle
import com.trendyol.ui.BaseFragment
import com.trendyol.ui.extensions.observeNonNull
import trendyol.com.R
import trendyol.com.databinding.${bindingClass}

class ${fragmentName} : BaseFragment<${bindingClass}>() {

    private val ${viewModelFieldName} by lazy(LazyThreadSafetyMode.NONE) {
        fragmentViewModelProvider.get(${viewModelClassName}::class.java)
    }

    override fun getScreenKey(): String = SCREEN_KEY

    override fun getLayoutId(): Int = R.layout.${layout}

    <#if generatePageViewState>
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        with(${viewModelFieldName}) {
            ${pageViewStatePublicMethodName}().observeNonNull(this@${fragmentName}) { renderPageViewState(it) }
        }
    }

    fun renderPageViewState(pageViewState: ${pageViewStateClassName}) {
        with(binding) {
            viewState = pageViewState
            executePendingBindings()
        }
    }
    </#if>
    
    companion object {

        private const val SCREEN_KEY = "${screenKey}"

        fun newInstance(args: Bundle?): ${className}Fragment {
            val fragment = ${className}Fragment()
            fragment.arguments = args
            return fragment
        }
    }
}
