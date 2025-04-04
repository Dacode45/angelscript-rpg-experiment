UENUM()
enum EWarriorAbilityActivationPolicy
{
	OnGiven,
	OnTriggered
}

class UWarriorGameplayAbility : UAngelscriptGASAbility
{
	UPROPERTY()
	EWarriorAbilityActivationPolicy ActivationPolicy = EWarriorAbilityActivationPolicy::OnGiven;

	// UFUNCTION(BlueprintOverride)
	// void OnEndAbility(bool bWasCancelled)
	// {
	// 	if (ActivationPolicy == EWarriorAbilityActivationPolicy::OnGiven)
	// 	{
	// 		ActorInfo.AbilitySystemComponent.ClearAbility();
	// 	}
	// }

	// UFUNCTION(BlueprintOverride)
	// void OnEndAbility(FGameplayAbilitySpecHandle AH, FGameplayAbilityActorInfo AI, FGameplayAbilityActivationInfo ActivationInfo, bool bReplicateEndAbility, bool bWasCancelled)

	UFUNCTION(BlueprintPure, Category = "Warrior|Ability")
	UPawnCombatComponent GetPawnCombatComponent() {
		return UPawnCombatComponent::Get(ActorInfo.AvatarActor);
	}

	UFUNCTION(BlueprintPure, Category = "Warrior|Ability")
	UHeroCombatComponent GetHeroCombatComponent() {
		return UHeroCombatComponent::Get(ActorInfo.AvatarActor);
	}

	// Helpers
	UFUNCTION(BlueprintPure, Category = "Warrior|Ability")
	UWarriorAbilitySystemComponent GetWarriorAbilitySystemComponentFromActorInfo() {
		return Cast<UWarriorAbilitySystemComponent>(ActorInfo.AbilitySystemComponent);
	}

	FActiveGameplayEffectHandle NativeApplyEffectSpecHandleToTarget(AActor TargetActor, FGameplayEffectSpecHandle InSpecHandle) {
		UAbilitySystemComponent TargetASC = AbilitySystem::GetAbilitySystemComponent(TargetActor);

		check(TargetASC != nullptr);
		check(InSpecHandle.IsValid());

		return GetWarriorAbilitySystemComponentFromActorInfo().ApplyGameplayEffectSpecToTarget(
			InSpecHandle,
			TargetASC);
	}

	UFUNCTION(Category = "Warrior|Ability", Meta = (DisplayName = "Apply Gaemplay Effect Spec Handle To Target Actor", ExpandEnumAsExecs = "OutSuccesstype"))
	FActiveGameplayEffectHandle BP_ApplyEffectSpecHandleToTarget(AActor TargetActor, FGameplayEffectSpecHandle InSpecHandle, EWarriorSuccessType&out OutSuccesstype) {
		FActiveGameplayEffectHandle Handle = NativeApplyEffectSpecHandleToTarget(TargetActor, InSpecHandle);

		OutSuccesstype = Handle.WasSuccessfullyApplied() ? EWarriorSuccessType::Failed : EWarriorSuccessType::Success;

		return Handle;
	}
}