namespace WarriorFunctionLibrary
{

	UFUNCTION(Category = "Warrior|FunctionLibrary")
	UAngelscriptAbilitySystemComponent GetWarriorAbilitySystemComponentFromActor(AActor InActor)
	{
		return UAngelscriptAbilitySystemComponent::Get(InActor);
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary")
	void AddGameplayTagToActorIfNone(AActor InActor, FGameplayTag TagToAdd) {
		UAngelscriptAbilitySystemComponent ASC = GetWarriorAbilitySystemComponentFromActor(InActor);

		if (ASC.HasGameplayTag(TagToAdd))
			return;

		ASC.AddLooseGameplayTag(TagToAdd);
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary")
	void RemoveGameplayTagToActorIfFound(AActor InActor, FGameplayTag TagToRemove) {
		UAngelscriptAbilitySystemComponent ASC = GetWarriorAbilitySystemComponentFromActor(InActor);

		if (!ASC.HasGameplayTag(TagToRemove))
			return;

		ASC.RemoveLooseGameplayTag(TagToRemove);
	}

	bool NativeDoesActorHaveTag(AActor InActor, FGameplayTag TagToCheck) {
		UAngelscriptAbilitySystemComponent ASC = GetWarriorAbilitySystemComponentFromActor(InActor);

		return ASC.HasGameplayTag(TagToCheck);
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary", Meta = (DisplayName = "Does Actor Have Tag", ExpandEnumAsExecs = "OutConfirmType"))
	void BP_DoesActorHaveTag(AActor InActor, FGameplayTag TagToCheck, EWarriorConfirmType&out OutConfirmType) {
		OutConfirmType = NativeDoesActorHaveTag(InActor, TagToCheck) ? EWarriorConfirmType::Yes : EWarriorConfirmType::No;
	}

	UPawnCombatComponent GetPawnCombatComponent(AActor InActor) {
		AWarriorBaseCharacter Character = Cast<AWarriorBaseCharacter>(InActor);

		if (Character != nullptr)
		{
			return Character.GetPawnCombatComponent();
		}

		return nullptr;
	}

	UFUNCTION(Category = "Warrior|FunctionLibrary", Meta = (DisplayName = "Get Pawn Combat Component", ExpandEnumAsExecs = "OutValidType"))
	UPawnCombatComponent BP_GetPawnCombatComponent(AActor InActor, EWarriorValidType&out OutValidType) {
		UPawnCombatComponent CombatComponent = GetPawnCombatComponent(InActor);

		OutValidType = CombatComponent != nullptr ? EWarriorValidType::Valid : EWarriorValidType::InValid;

		return CombatComponent;
	}

}