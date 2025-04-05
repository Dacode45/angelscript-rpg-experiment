

// class UWarriorAbilitySystemComponent : UAngelscriptAbilitySystemComponent
// {

namespace WarriorAbilitySystemComponent
{

	UFUNCTION(Meta = (ApplyLevel = 1))
	void GrantHeroWeaponAbilities(UAngelscriptAbilitySystemComponent InASCComp, TArray<FWarriorHeroAbilitySet> InAbilitySet, int32 ApplyLevel, TArray<FGameplayAbilitySpecHandle>&out OutAbilitySpecHandles){
		InASCComp.NativeGrantHeroWeaponAbilities(InAbilitySet, ApplyLevel, OutAbilitySpecHandles);
	}

	UFUNCTION()
	void RemovedGrantedHeroWeaponAbilities(UAngelscriptAbilitySystemComponent InASCComp, TArray<FGameplayAbilitySpecHandle>& InAbilitiesToRemove) {
		InASCComp.NativeRemovedGrantedHeroWeaponAbilities(InAbilitiesToRemove);
	}

}

mixin void NativeGrantHeroWeaponAbilities(UAngelscriptAbilitySystemComponent Self, TArray<FWarriorHeroAbilitySet> InAbilitySet, int32 ApplyLevel, TArray<FGameplayAbilitySpecHandle>&out OutAbilitySpecHandles)
{
	if (InAbilitySet.IsEmpty())
		return;

	for (FWarriorHeroAbilitySet Set : InAbilitySet)
	{

		FGameplayAbilitySpec AbilitySpec(Set.AbilityToGrant);

		AbilitySpec.SourceObject = Self.AbilityActorInfo.AvatarActor;
		AbilitySpec.Level = ApplyLevel;
		AbilitySpec.DynamicAbilityTags.AddTag(Set.InputTag);

		FGameplayAbilitySpecHandle Handle = Self.GiveAbility(AbilitySpec);
		OutAbilitySpecHandles.AddUnique(Handle);
	}
}

mixin void NativeRemovedGrantedHeroWeaponAbilities(UAngelscriptAbilitySystemComponent Self, TArray<FGameplayAbilitySpecHandle>& InAbilitiesToRemove)
{

	if (InAbilitiesToRemove.IsEmpty())
		return;

	for (FGameplayAbilitySpecHandle Handle : InAbilitiesToRemove)
	{
		Self.ClearAbility(Handle);
	}

	InAbilitiesToRemove.Empty();
}

mixin void OnInput(UAngelscriptAbilitySystemComponent Self, FGameplayTag InputTag, bool bShouldActivate)
{

	if (!InputTag.IsValid())
		return;

	// Debug::Print(f"OnINput: {InputTag}: {bShouldActivate}");

	TArray<FGameplayAbilitySpecHandle> handles();
	Self.GetAllAbilities(handles);

	FGameplayAbilitySpec spec;
	for (FGameplayAbilitySpecHandle handle : handles)
	{

		Self.FindAbilitySpecFromHandle(handle, spec);

		if (bShouldActivate && !Self.CanActivateAbilitySpec(handle))
			continue;

		if (!spec.DynamicAbilityTags.HasTag(InputTag))
			continue;

		if (bShouldActivate)
		{

			auto bWasActivated = Self.TryActivateAbility(handle);
			// Debug::Print(f"Checking Ability {spec.DebugString}: {bWasActivated}");
		}
	}
}

mixin void OnAbilityInputPressed(UAngelscriptAbilitySystemComponent Self, FGameplayTag InputTag)
{
	Self.OnInput(InputTag, true);
}

mixin void OnAbilityInputReleased(UAngelscriptAbilitySystemComponent Self, FGameplayTag InputTag)
{
	// Self.OnInput(InputTag, true);
}