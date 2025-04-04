struct FWarriorDamageCapture
{
	FGameplayEffectAttributeCaptureDefinition AttackPowerCaptureDefinition;
	FGameplayEffectAttributeCaptureDefinition DefensePowerCaptureDefinition;
	FGameplayEffectAttributeCaptureDefinition DamageTakenCaptureDefinition;

	FWarriorDamageCapture()
	{
		AttackPowerCaptureDefinition =
			CustomGAS::CaptureGameplayAttribute(UWarriorAttributeSet, n"AttackPower", EGameplayEffectAttributeCaptureSource::Source, false);

		DefensePowerCaptureDefinition =
			CustomGAS::CaptureGameplayAttribute(UWarriorAttributeSet, n"DefensePower", EGameplayEffectAttributeCaptureSource::Source, false);

		DefensePowerCaptureDefinition =
			CustomGAS::CaptureGameplayAttribute(UWarriorAttributeSet, n"DamageTaken", EGameplayEffectAttributeCaptureSource::Source, false);
	}
}

class UGEExecCalc_DamageTaken : UGameplayEffectExecutionCalculation
{
	UGEExecCalc_DamageTaken()
	{

		FGameplayEffectAttributeCaptureDefinition AttackPowerCaptureDefinition =
			CustomGAS::CaptureGameplayAttribute(UWarriorAttributeSet, n"AttackPower", EGameplayEffectAttributeCaptureSource::Source, false);

		FGameplayEffectAttributeCaptureDefinition DefensePowerCaptureDefinition =
			CustomGAS::CaptureGameplayAttribute(UWarriorAttributeSet, n"DefensePower", EGameplayEffectAttributeCaptureSource::Source, false);

		FGameplayEffectAttributeCaptureDefinition t = FGameplayEffectAttributeCaptureDefinition();
		// RelevantAttributesToCapture.Add(AttackPowerCaptureDefinition);

		return;
	}

	UFUNCTION(BlueprintOverride)
	void Execute(FGameplayEffectCustomExecutionParameters ExecutionParams,
				 FGameplayEffectCustomExecutionOutput& OutExecutionOutput) const
	{
		FWarriorDamageCapture DamageCapture();

		FGameplayEffectSpec EffectSpec = ExecutionParams.OwningSpec;

		FGameplayEffectExecutionParameters EvaluateParameters;
		EvaluateParameters.SetCapturedSourceTagsFromSpec(EffectSpec);

		float32 SourceAttackPower = 0.f;
		// float& SourceAttackPowerRef = &SourceAttackPower;
		ExecutionParams.AttemptCalculateCapturedAttributeMagnitude(
			DamageCapture.AttackPowerCaptureDefinition, EvaluateParameters, SourceAttackPower);

		float BaseDamage = 0.f;
		int32 UsedLightAttackComboCount = 0;
		int32 UsedHeavyAttackComboCount = 0;

		for (auto TagMagnitude : EffectSpec.SetByCallerTagMagnitudes)
		{
			if (TagMagnitude.Key.MatchesTagExact(GameplayTags::Shared_SetByCaller_BaseDamage))
			{
				BaseDamage = TagMagnitude.Value;
			}

			if (TagMagnitude.Key.MatchesTagExact(GameplayTags::Player_SetByCaller_AttackType_Light))
			{
				UsedLightAttackComboCount = TagMagnitude.Value;
			}

			if (TagMagnitude.Key.MatchesTagExact(GameplayTags::Player_SetByCaller_AttackType_Heavy))
			{
				UsedHeavyAttackComboCount = TagMagnitude.Value;
			}

			float32 TargetDefensePower = 0.f;
			ExecutionParams.AttemptCalculateCapturedAttributeMagnitude(DamageCapture.DefensePowerCaptureDefinition, EvaluateParameters, TargetDefensePower);

			if (UsedLightAttackComboCount > 0)
			{
				BaseDamage *= (UsedLightAttackComboCount - 1) * 0.05 + 1.f;
			}

			if (UsedHeavyAttackComboCount > 0)
			{
				BaseDamage *= (UsedHeavyAttackComboCount - 1) * 0.15 + 1.f;
			}

			const float FinalDamageDone = BaseDamage * SourceAttackPower / TargetDefensePower;

			FGameplayModifierEvaluatedData ModEvaluatedData = UAngelscriptGameplayEffectUtils::MakeGameplayModifierEvaluationData(
				UWarriorAttributeSet.DefaultObject.AttackPower,
				EGameplayModOp::Override,
				FinalDamageDone);

			if (FinalDamageDone > 0)
			{
				OutExecutionOutput.AddOutputModifier(
					ModEvaluatedData);
			}
		}
	}
}