class UDataAsset_StartupDataBase : UDataAsset
{
	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UWarriorGameplayAbility>> ActivateOnGivenAbilities;

	UPROPERTY(EditDefaultsOnly, Category = "StartupData")
	TArray<TSubclassOf<UWarriorGameplayAbility>> ReactiveAbilities;

	void GiveToAbilitySystemComponent(UWarriorAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel) {
		check(InWarriorAbilitySystem != nullptr);
	}

	void GrantAbility(TArray<TSubclassOf<UWarriorGameplayAbility>> InAbilitiesToGive, UWarriorAbilitySystemComponent InWarriorAbilitySystem, int32 ApplyLevel) {
		if (InAbilitiesToGive.IsEmpty())
		{
			return;
		}

		for (auto Ability : InAbilitiesToGive)
		{
			FGameplayAbilitySpec AbilitySpec = FGameplayAbilitySpec(Ability);

			AbilitySpec.SourceObject = InWarriorAbilitySystem.AbilityActorInfo.AvatarActor;
			AbilitySpec.Level = ApplyLevel;

			InWarriorAbilitySystem.GiveAbility(AbilitySpec);
		}
	}
}