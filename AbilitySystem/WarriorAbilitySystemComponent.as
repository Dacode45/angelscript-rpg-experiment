class UWarriorAbilitySystemComponent : UAngelscriptAbilitySystemComponent
{

	UFUNCTION(Meta = (ApplyLevel = 1))
	void GrantHeroWeaponAbilities(TArray<FWarriorHeroAbilitySet> InAbilitySet, int32 ApplyLevel, TArray<FGameplayAbilitySpecHandle>&out OutAbilitySpecHandles) {
		if (InAbilitySet.IsEmpty())
			return;

		for (FWarriorHeroAbilitySet Set : InAbilitySet)
		{

			FGameplayAbilitySpec AbilitySpec(Set.AbilityToGrant);

			AbilitySpec.SourceObject = AbilityActorInfo.AvatarActor;
			AbilitySpec.Level = ApplyLevel;
			AbilitySpec.DynamicAbilityTags.AddTag(Set.InputTag);

			FGameplayAbilitySpecHandle Handle = GiveAbility(AbilitySpec);
			OutAbilitySpecHandles.AddUnique(Handle);
		}
	}

	UFUNCTION()
	void RemovedGrantedHeroWeaponAbilities(TArray<FGameplayAbilitySpecHandle>& InAbilitiesToRemove) {

		if (InAbilitiesToRemove.IsEmpty())
			return;

		for (FGameplayAbilitySpecHandle Handle : InAbilitiesToRemove)
		{
			ClearAbility(Handle);
		}

		InAbilitiesToRemove.Empty();
	}

	void OnInput(FGameplayTag InputTag, bool bShouldActivate) {

		if (!InputTag.IsValid())
			return;

		// Debug::Print(f"OnINput: {InputTag}: {bShouldActivate}");

		TArray<FGameplayAbilitySpecHandle> handles();
		GetAllAbilities(handles);

		FGameplayAbilitySpec spec;
		for (FGameplayAbilitySpecHandle handle : handles)
		{

			FindAbilitySpecFromHandle(handle, spec);

			if (bShouldActivate && !CanActivateAbilitySpec(handle))
				continue;

			if (!spec.DynamicAbilityTags.HasTag(InputTag))
				continue;

			if (bShouldActivate)
			{

				auto bWasActivated = TryActivateAbility(handle);
				// Debug::Print(f"Checking Ability {spec.DebugString}: {bWasActivated}");
			}
		}
	}

	void OnAbilityInputPressed(FGameplayTag InputTag) {
		OnInput(InputTag, true);
	}

	void OnAbilityInputReleased(FGameplayTag InputTag) {
		// OnInput(InputTag, true);
	}
}