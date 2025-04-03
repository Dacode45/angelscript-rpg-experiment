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

	void BindAbilityInputAction(UDataAsset_InputConfig InInputConfig,
								FEnhancedInputActionHandlerDynamicSignature PressedFunc, FEnhancedInputActionHandlerDynamicSignature ReleasedFunc)
	{
		check(InInputConfig != nullptr);

		for (FWarriorInputActionConfig config : InInputConfig.AbilityInputActions)
		{
			if (!config.IsValid())
				continue;

			BindAction(config.InputAction, ETriggerEvent::Started, PressedFunc);
			BindAction(config.InputAction, ETriggerEvent::Completed, ReleasedFunc);
		}
	}
}