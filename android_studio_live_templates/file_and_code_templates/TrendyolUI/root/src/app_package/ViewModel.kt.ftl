package ${packageName}

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import com.trendyol.ui.common.RxAwareViewModel
import javax.inject.Inject
<#assign pageViewStateClassName = className + 'PageViewState'>
<#assign pageViewStateFieldName = pageViewStateClassName?substring(0,1)?lower_case + pageViewStateClassName?substring(1) + 'LiveData'>
<#assign pageViewStatePublicMethodName = 'get' + pageViewStateClassName + 'LiveData'>

class ${className}ViewModel @Inject constructor() : RxAwareViewModel() {

	<#if generatePageViewState>
    private val ${pageViewStateFieldName}: MutableLiveData<${pageViewStateClassName}> = MutableLiveData()

    fun ${pageViewStatePublicMethodName}(): LiveData<${pageViewStateClassName}> = ${pageViewStateFieldName}
	</#if>

}
