USTRUCT()
struct FWarriorInputActionConfig
{

	UPROPERTY()
	FGameplayTag InputTag;

	UPROPERTY()
	UInputAction InputAction;

	bool IsValid() const {
		return InputTag.IsValid() && InputAction != nullptr;
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

	UInputAction FindNativeInputActionByTag(FGameplayTag InInputTag)
	{
		for (FWarriorInputActionConfig& config : NativeInputActions)
		{
			if (config.InputTag == InInputTag)
			{
				check(config.IsValid());

				return config.InputAction;
			}
		}

		return nullptr;
	}
}