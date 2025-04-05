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
	UAngelscriptAbilitySystemComponent GetWarriorAbilitySystemComponentFromActorInfo() {
		return Cast<UAngelscriptAbilitySystemComponent>(ActorInfo.AbilitySystemComponent);
	}

	FActiveGameplayEffectHandle NativeApplyEffectSpecHandleToTarget(AActor TargetActor, FGameplayEffectSpecHandle InSpecHandle) {
		UAbilitySystemComponent TargetASC = AbilitySystem::GetAbilitySystemComponent(TargetActor);

		if (TargetASC == nullptr)
			return FActiveGameplayEffectHandle();

		check(TargetASC != nullptr);
		check(InSpecHandle.IsValid());

		return GetWarriorAbilitySystemComponentFromActorInfo().ApplyGameplayEffectSpecToTarget(
			InSpecHandle,
			TargetASC);
	}

	UFUNCTION(Category = "Warrior|Ability", Meta = (DisplayName = "Apply Gaemplay Effect Spec Handle To Target Actor", ExpandEnumAsExecs = "OutSuccesstype"))
	FActiveGameplayEffectHandle BP_ApplyEffectSpecHandleToTarget(AActor TargetActor, FGameplayEffectSpecHandle InSpecHandle, EWarriorSuccessType&out OutSuccesstype) {
		FActiveGameplayEffectHandle Handle = NativeApplyEffectSpecHandleToTarget(TargetActor, InSpecHandle);

		OutSuccesstype = Handle.WasSuccessfullyApplied() ? EWarriorSuccessType::Success : EWarriorSuccessType::Failed;

		return Handle;
	}
}