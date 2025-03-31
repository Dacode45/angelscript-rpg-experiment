
// Initialized by the Controller
class UWarriorInputComponent : UEnhancedInputComponent
{
	void BindNativeInputAction(UDataAsset_InputConfig InInputConfig,
							   const FGameplayTag& InInputTag, ETriggerEvent TriggerEvent,
							   FEnhancedInputActionHandlerDynamicSignature CallbackFunc)
	{
		check(InInputConfig != nullptr);

		UInputAction FoundAction = InInputConfig.FindNativeInputActionByTag(InInputTag);
		if (FoundAction != nullptr)
		{
			BindAction(FoundAction, TriggerEvent, CallbackFunc);
		}
		else
		{
			Debug::Print("Input action not found.");
		}
	}
}