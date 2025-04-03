namespace WarriorFunctionLibrary
{

	UENUM()
	enum EWarriorConfirmType
	{
		Yes,
		No
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary")
	UWarriorAbilitySystemComponent GetWarriorAbilitySystemComponentFromActor(AActor InActor)
	{
		return UWarriorAbilitySystemComponent::Get(InActor);
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary")
	void AddGameplayTagToActorIfNone(AActor InActor, FGameplayTag TagToAdd) {
		UWarriorAbilitySystemComponent ASC = GetWarriorAbilitySystemComponentFromActor(InActor);

		if (ASC.HasGameplayTag(TagToAdd))
			return;

		ASC.AddLooseGameplayTag(TagToAdd);
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary")
	void RemoveGameplayTagToActorIfFound(AActor InActor, FGameplayTag TagToRemove) {
		UWarriorAbilitySystemComponent ASC = GetWarriorAbilitySystemComponentFromActor(InActor);

		if (!ASC.HasGameplayTag(TagToRemove))
			return;

		ASC.RemoveLooseGameplayTag(TagToRemove);
	}

	bool NativeDoesActorHaveTag(AActor InActor, FGameplayTag TagToCheck) {
		UWarriorAbilitySystemComponent ASC = GetWarriorAbilitySystemComponentFromActor(InActor);

		return ASC.HasGameplayTag(TagToCheck);
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary", Meta = (DisplayName = "Does Actor Have Tag", ExpandEnumAsExecs = "OutConfirmType"))
	void BP_DoesActorHaveTag(AActor InActor, FGameplayTag TagToCheck, EWarriorConfirmType&out OutConfirmType) {
		OutConfirmType = NativeDoesActorHaveTag(InActor, TagToCheck) ? EWarriorConfirmType::Yes : EWarriorConfirmType::No;
	}

}