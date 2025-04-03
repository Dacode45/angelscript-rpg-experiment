class UInputActionWithTag : UInputAction
{
	UPROPERTY()
	FGameplayTag InputTag;

}

USTRUCT()
struct FWarriorInputActionConfig
{
	FGameplayTag GetInputTag() const property {
		if (InputAction == nullptr)
			return FGameplayTag();

		return InputAction.InputTag;
	}

	UPROPERTY()
	UInputActionWithTag InputAction;

	bool IsValid() const {
		return InputAction != nullptr && InputAction.InputTag.IsValid();
	}
}

class UDataAsset_InputConfig : UDataAsset
{

	UPROPERTY()
	UInputMappingContext DefaultMappingContext;

	UPROPERTY()
	TArray<FWarriorInputActionConfig> NativeInputActions;

	UPROPERTY()
	TArray<FWarriorInputActionConfig> AbilityInputActions;

	UInputActionWithTag FindNativeInputActionByTag(FGameplayTag InInputTag)
	{
		return FindInputActionByTag(NativeInputActions, InInputTag);
	}

	UInputActionWithTag FindAbilityInputActionByTag(FGameplayTag InInputTag)
	{
		return FindInputActionByTag(AbilityInputActions, InInputTag);
	}

	UInputActionWithTag FindInputActionByTag(TArray<FWarriorInputActionConfig> Actions, FGameplayTag InInputTag) {
		for (FWarriorInputActionConfig config : Actions)
		{
			if (config.IsValid() && config.InputAction.InputTag == InInputTag)
			{
				return config.InputAction;
			}
		}

		return nullptr;
	}
}